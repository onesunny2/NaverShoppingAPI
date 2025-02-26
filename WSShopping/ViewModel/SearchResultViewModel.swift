//
//  SearchResultViewModel.swift
//  WSShopping
//
//  Created by Lee Wonsun on 2/6/25.
//

import Foundation
import RxCocoa
import RxSwift

final class SearchResultViewModel: BaseViewModel {
    
    struct Input {
        // 필터링 버튼의 태그를 전달받기 (버튼탭을 통해서)
        let buttonTag: [Observable<Int>]
        let prefetchIndexPath: ControlEvent<[IndexPath]>
    }
    
    struct Output {
        let totalCount: Driver<Int>
        let shoppingDetail: Driver<[ShoppingDetail]>
        let startPage: Driver<Int>
        let errorMessage: PublishRelay<String>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    private let group = DispatchGroup()
    let buttonTitle = Sort.allCases
    
    let keyword: String
    var sort: String
    var start: Int
    var isEnd: Bool
    
    init(keyword: String) {
        
        self.keyword = keyword
        self.sort = Sort.정확도.query
        self.start = 1
        self.isEnd = false
    }
    
    func transform(input: Input) -> Output {
        
        var results: [ShoppingDetail] = []
        
        let totalCount = BehaviorRelay(value: 0)
        let shoppingDetail = BehaviorRelay(value: results)
        let startPage = PublishRelay<Int>()
        let errorMessage = PublishRelay<String>()
        
        // MARK: 화면 진입 시 첫 통신
        AlamofireManager.shared.callRequestByObservable(type: Shopping.self, api: .shopping(keyword: keyword, sortName: sort, start: start))
            .catch { error in
                
                switch error as? ShoppingError {
                case .invalidURL: errorMessage.accept(ShoppingError.invalidURL.message)
                case let .statudError(code): errorMessage.accept(ShoppingError.statudError(code: code).message)
                case .unknownResponse: errorMessage.accept(ShoppingError.unknownResponse.message)
                default:
                    print("잘못된 에러")
                    break
                }
                
                let data = Shopping(total: 0, items: [ShoppingDetail(title: "", image: "", price: "", mallName: "")])
                return Single.just(data)
            }
            .debug("shopping")
            .asObservable()
            .bind(with: self) { this, value in
                results.append(contentsOf: value.items)
                
                shoppingDetail.accept(results)
                totalCount.accept(value.total)
            }
            .disposed(by: disposeBag)
        
        // MARK: 필터링 - 전달 받은 버튼의 태그값 활용
        input.buttonTag.forEach { value in
            value
                .distinctUntilChanged()
                .bind(with: self) { this, tag in
                    
                    results = []
                    
                    let sortList = Sort.allCases.map { $0.query }
                    this.sort = sortList[tag]
                    this.start = 1

                    AlamofireManager.shared.callRequestByObservable(type: Shopping.self, api: .shopping(keyword: this.keyword, sortName: this.sort, start: this.start))
                        .catch { error in
                            
                            print("shopping error", error)
                            
                            let data = Shopping(total: 0, items: [ShoppingDetail(title: "", image: "", price: "", mallName: "")])
                            return Single.just(data)
                        }
                        .debug("shopping")
                        .asObservable()
                        .bind(with: self) { this, value in
                            
                            results.append(contentsOf: value.items)
                            
                            shoppingDetail.accept(results)
                            totalCount.accept(value.total)
                            
                            startPage.accept(this.start)
                        }
                        .disposed(by: this.disposeBag)
                }
                .disposed(by: disposeBag)
        }
 
        input.prefetchIndexPath
            .bind(with: self) { this, indexPaths in
                print("result.count===", results.count)
                for item in indexPaths {
                    if (results.count - 6 == item.item) && results.count < totalCount.value && !this.isEnd {
                        this.start += results.count
                        
                        print("totalCount===", totalCount)
                        print("start===", this.start)
                        print("isEnd===", this.isEnd)
                        
                        AlamofireManager.shared.callRequestByObservable(type: Shopping.self, api: .shopping(keyword: this.keyword, sortName: this.sort, start: this.start))
                            .catch { error in
                                
                                print("shopping error", error)
                                
                                let data = Shopping(total: 0, items: [ShoppingDetail(title: "", image: "", price: "", mallName: "")])
                                return Single.just(data)
                            }
                            .debug("shopping")
                            .asObservable()
                            .bind(with: self) { this, value in
                                
                                results.append(contentsOf: value.items)
                                
                                shoppingDetail.accept(results)
                                totalCount.accept(value.total)
                                
                                if results.count >= value.total {
                                    this.isEnd = true
                                }
                            }
                            .disposed(by: this.disposeBag)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            totalCount: totalCount.asDriver(),
            shoppingDetail: shoppingDetail.asDriver(),
            startPage: startPage.asDriver(onErrorJustReturn: 1),
            errorMessage: errorMessage
        )
    }
}
