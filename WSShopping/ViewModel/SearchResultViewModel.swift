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
        //
    }
    
    struct Output {
        let totalCount: Driver<Int>
        let shoppingDetail: Driver<[ShoppingDetail]>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let keyword: String

    typealias Query = (String, String, Int)
    var inputQuery: Observable<Query> = Observable(("", "sim", 1))
    let inputRequest: Observable<Void> = Observable(())
    let inputPrefetch: Observable<[IndexPath]> = Observable([])
    
    let outputRequest: Observable<[ShoppingDetail?]> = Observable([])
    let outputReloadAction: Observable<Void> = Observable(())
    var outputStart: Observable<Int> = Observable(1)
    let outputTotal: Observable<Int> = Observable(0)
    var outputIsEnd: Observable<Bool> = Observable(false)
    
    init(keyword: String) {
        
        self.keyword = keyword
        
//        AlamofireManager.shared.callRequestByObservable(type: Shopping.self, api: .shopping(keyword: keyword, sortName: "sim", start: 1))
//            .catch { error in
//                
//                print("shopping error", error)
//                
//                let data = Shopping(total: 0, items: [ShoppingDetail(title: "", image: "", price: "", mallName: "")])
//                return Single.just(data)
//            }
//            .debug("shopping")
//            .asObservable()
//            .bind(with: self) { this, value in
//                dump(value)
//            }
//            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        
        let totalCount = BehaviorRelay(value: 0)
        let shoppingDetail = BehaviorRelay(value: [ShoppingDetail(title: "", image: "", price: "", mallName: "")])
        
        // MARK: 화면 진입 시 첫 통신
        AlamofireManager.shared.callRequestByObservable(type: Shopping.self, api: .shopping(keyword: keyword, sortName: Sort.정확도.query, start: 1))
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
        
        return Output(
            totalCount: totalCount.asDriver(),
            shoppingDetail: shoppingDetail.asDriver()
        )
    }
    
    private func checkPagenation(_ itemCount: Int) {
        
        let list = outputRequest.value
        var start = self.outputStart.value
        var end = self.outputIsEnd.value
        let total = self.outputTotal.value
        
        print("list: ", list.count)
        if list.count - 5 == itemCount && list.count < total {
            start += list.count
            print("start: ", start)
        } else if list.count >= total {
            end = true
        }
    }
}
