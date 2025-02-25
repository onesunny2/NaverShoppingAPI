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
    }
    
    struct Output {
        let totalCount: Driver<Int>
        let shoppingDetail: Driver<[ShoppingDetail]>
        let startPage: Driver<Int>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    let buttonTitle = Sort.allCases
    
    let keyword: String
    var sort: String
    var start: Int
    
    init(keyword: String) {
        
        self.keyword = keyword
        self.sort = Sort.정확도.query
        self.start = 1
    }
    
    func transform(input: Input) -> Output {
        
        let totalCount = BehaviorRelay(value: 0)
        let shoppingDetail = BehaviorRelay(value: [ShoppingDetail(title: "", image: "", price: "", mallName: "")])
        let startPage = BehaviorRelay(value: 1)
        
        // MARK: 화면 진입 시 첫 통신
        AlamofireManager.shared.callRequestByObservable(type: Shopping.self, api: .shopping(keyword: keyword, sortName: sort, start: start))
            .catch { error in
                
                print("shopping error", error)
                
                let data = Shopping(total: 0, items: [ShoppingDetail(title: "", image: "", price: "", mallName: "")])
                return Single.just(data)
            }
            .debug("shopping")
            .asObservable()
            .bind(with: self) { this, value in
                shoppingDetail.accept(value.items)
                totalCount.accept(value.total)
            }
            .disposed(by: disposeBag)
        
        // MARK: 전달 받은 버튼의 태그값 활용
        input.buttonTag.forEach { value in
            value
                .distinctUntilChanged()
                .bind(with: self) { this, tag in
                    let sortList = Sort.allCases.map { $0.query }
                    this.sort = sortList[tag]
                    this.start = 1
                    startPage.accept(this.start)
                    
                    AlamofireManager.shared.callRequestByObservable(type: Shopping.self, api: .shopping(keyword: this.keyword, sortName: this.sort, start: this.start))
                        .catch { error in
                            
                            print("shopping error", error)
                            
                            let data = Shopping(total: 0, items: [ShoppingDetail(title: "", image: "", price: "", mallName: "")])
                            return Single.just(data)
                        }
                        .debug("shopping")
                        .asObservable()
                        .bind(with: self) { this, value in
                            shoppingDetail.accept(value.items)
                            totalCount.accept(value.total)
                        }
                        .disposed(by: this.disposeBag)
                }
                .disposed(by: disposeBag)
        }
 
        
        return Output(
            totalCount: totalCount.asDriver(),
            shoppingDetail: shoppingDetail.asDriver(),
            startPage: startPage.asDriver()
        )
    }
}
