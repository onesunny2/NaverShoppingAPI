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
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let keyword: String
    var sort: String
    var start: Int

    typealias Query = (String, String, Int)
//    var inputQuery: Observable<Query> = Observable(("", "sim", 1))
//    let inputRequest: Observable<Void> = Observable(())
//    let inputPrefetch: Observable<[IndexPath]> = Observable([])
//    
//    let outputRequest: Observable<[ShoppingDetail?]> = Observable([])
//    let outputReloadAction: Observable<Void> = Observable(())
//    var outputStart: Observable<Int> = Observable(1)
//    let outputTotal: Observable<Int> = Observable(0)
//    var outputIsEnd: Observable<Bool> = Observable(false)
    
    init(keyword: String) {
        
        self.keyword = keyword
        self.sort = Sort.정확도.query
        self.start = 1
    }
    
    func transform(input: Input) -> Output {
        
        let totalCount = BehaviorRelay(value: 0)
        let shoppingDetail = BehaviorRelay(value: [ShoppingDetail(title: "", image: "", price: "", mallName: "")])
        
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
                .bind(with: self) { this, tag in
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
                            shoppingDetail.accept(value.items)
                            totalCount.accept(value.total)
                        }
                        .disposed(by: this.disposeBag)
                }
                .disposed(by: disposeBag)
        }
            
            
//            .disposed(by: disposeBag)
        
        return Output(
            totalCount: totalCount.asDriver(),
            shoppingDetail: shoppingDetail.asDriver()
        )
    }
    
//    private func checkPagenation(_ itemCount: Int) {
//        
//        let list = outputRequest.value
//        var start = self.outputStart.value
//        var end = self.outputIsEnd.value
//        let total = self.outputTotal.value
//        
//        print("list: ", list.count)
//        if list.count - 5 == itemCount && list.count < total {
//            start += list.count
//            print("start: ", start)
//        } else if list.count >= total {
//            end = true
//        }
//    }
}
