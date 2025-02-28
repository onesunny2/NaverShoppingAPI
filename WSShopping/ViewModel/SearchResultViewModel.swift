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
        let tappedProduct: ControlEvent<ShoppingDetail>
    }
    
    struct Output {
        let totalCount: Driver<Int>
        let shoppingDetail: Driver<[ShoppingDetail]>
        let startPage: Driver<Int>
        let errorMessage: PublishRelay<ShoppingError>
        let webView: Driver<DetailWebViewViewController>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    private let group = DispatchGroup()
    let buttonTitle = Sort.allCases
    
    let keyword: String
    private var sort: String
    private var start: Int
    private var isEnd: Bool
    
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
        let errorMessage = PublishRelay<ShoppingError>()
        let webView = PublishRelay<DetailWebViewViewController>()
 
        // MARK: 화면 진입 시 첫 통신
        getNetworkResult(errorMessage: errorMessage, keyword: keyword, sort: sort, start: start)
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

                    this.getNetworkResult(errorMessage: errorMessage, keyword: this.keyword, sort: this.sort, start: this.start)
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
                
                for item in indexPaths {
                    if (results.count - 6 == item.item) && results.count < totalCount.value && !this.isEnd {
                        this.start += 30
                        
                        this.getNetworkResult(errorMessage: errorMessage, keyword: this.keyword, sort: this.sort, start: this.start)
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
        
        input.tappedProduct
            .map { $0.link }
            .bind(with: self) { this, url in
                let vc = DetailWebViewViewController(url: url)
                webView.accept(vc)
            }
            .disposed(by: disposeBag)
        
        return Output(
            totalCount: totalCount.asDriver(),
            shoppingDetail: shoppingDetail.asDriver(),
            startPage: startPage.asDriver(onErrorJustReturn: 1),
            errorMessage: errorMessage,
            webView: webView.asDriver(onErrorJustReturn: DetailWebViewViewController(url: ""))
        )
    }
}

extension SearchResultViewModel {
    
    private func getNetworkResult(errorMessage: PublishRelay<ShoppingError>, keyword: String, sort: String, start: Int) -> Observable<Shopping> {
        
        let network = AlamofireManager.shared.callRequestByObservable(type: Shopping.self, api: .shopping(keyword: keyword, sortName: sort, start: start))
            .catch { error in
                
                switch error as? ShoppingError {
                case .invalidURL: errorMessage.accept(ShoppingError.invalidURL)
                case let .statudError(code, message): errorMessage.accept(ShoppingError.statudError(code: code, message: message))
                case .unknownResponse: errorMessage.accept(ShoppingError.unknownResponse)
                default:
                    print("잘못된 에러")
                    break
                }
                
                let data = Shopping(total: 0, items: [ShoppingDetail(title: "", link: "", image: "", price: "", mallName: "")])
                return Single.just(data)
            }
            .debug("shopping")
            .asObservable()
        
        return network
    }
}
