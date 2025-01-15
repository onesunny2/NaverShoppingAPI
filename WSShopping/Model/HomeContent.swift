//
//  ResultContent.swift
//  WSShopping
//
//  Created by Lee Wonsun on 1/15/25.
//

import Foundation

enum Contents {
    case imageName
    case labelText
}

struct HomeContent {
    
    static let title = "원선's 쇼핑치링치링"
    static let placeholder = "브랜드, 상품, 프로필, 태그 등"
    
    var isValid: Bool
  
    func isValidCheck(content: Contents) -> String {
        
        switch content {
        case .imageName:
            if isValid {
                return "shopping"
            } else {
                return "nono"
            }
        case .labelText:
            if isValid {
                return "이것도 사고 저것도 살래 :>"
            } else {
                return "2글자 이상으로 검색해주세요!"
            }
        }
    }
    
}


