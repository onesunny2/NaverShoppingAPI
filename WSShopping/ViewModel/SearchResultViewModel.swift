//
//  SearchResultViewModel.swift
//  WSShopping
//
//  Created by Lee Wonsun on 2/6/25.
//

import Foundation


final class SearchResultViewModel {

    typealias Query = (String, String, Int)
    var inputQuery: Observable<Query> = Observable(("", "sim", 1))
    let inputRequest: Observable<Void> = Observable(())
    let inputPrefetch: Observable<[IndexPath]> = Observable([])
    
    let outputRequest: Observable<[ShoppingDetail?]> = Observable([])
    let outputReloadAction: Observable<Void> = Observable(())
    var outputStart: Observable<Int> = Observable(1)
    let outputTotal: Observable<Int> = Observable(0)
    var outputIsEnd: Observable<Bool> = Observable(false)
    
    init() {
        
        inputQuery.lazyBind { data in
            
            let keyword = data.0
            let sort = data.1
            let start = data.2
            
            print("inputkeyword.bind====", data)
            self.getSearchResult(keyword, sort, start)
        }
        
        inputRequest.lazyBind { _ in
            let keyword = self.inputQuery.value.0
            let sort = self.inputQuery.value.1
            let start = self.inputQuery.value.2
            
            print("inputRequest.bind====", keyword, sort, start)
            self.getSearchResult(keyword, sort, start)
        }
        
        inputPrefetch.lazyBind { indexPaths in
            
            for item in indexPaths {
                
                self.checkPagenation(item.row)
            }
        }
    }
    
    private func getSearchResult(_ keyword: String, _ sort: String, _ start: Int) {
        AlamofireManager.shared.callRequest(Shopping.self, api: .shopping(keyword: keyword, sortName: sort, start: start)) { result in
            
            switch result {
            case .success(let success):

                self.outputRequest.value = success.items

                if start == 1 {
                    self.outputTotal.value = success.total
                    print(self.outputTotal.value)
                    self.outputReloadAction.value = ()
                } else {
                    self.outputRequest.value.append(contentsOf: success.items)
                }

            case .failure(let failure):
                print(failure)
            }
        }
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
