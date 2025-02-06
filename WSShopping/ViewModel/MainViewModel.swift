//
//  MainViewModel.swift
//  WSShopping
//
//  Created by Lee Wonsun on 2/6/25.
//

import Foundation

enum HomeContents: String {
    case validImage = "shopping"
    case inValidImage = "nono"
    case validText = "이것도 사고 저것도 살래 :>"
    case InvalidText = "2글자 이상으로 검색해주세요!"
}

final class MainViewModel {
    
    let inputSearchText: Observable<String?> = Observable("")
    
    let outputCheckValid: Observable<Bool> = Observable(true)
    
    init() {
        
        inputSearchText.lazyBind { [weak self] text in
            self?.checkKeywordValid()
        }
    }
    
    private func checkKeywordValid() {
        
        guard let keyword = inputSearchText.value else {
            print("keyword nil")
            return
        }
        
        switch keyword.count {
        case ..<2:
            outputCheckValid.value = false
        case 2...:
            outputCheckValid.value = true
        default:
            print("\(keyword.count) error")
            break
        }
    }
}

extension MainViewModel {
    
    func name(_ type: HomeContents) -> String {
        return type.rawValue
    }
}
