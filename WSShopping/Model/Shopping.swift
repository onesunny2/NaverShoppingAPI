//
//  Shopping.swift
//  WSShopping
//
//  Created by Lee Wonsun on 1/16/25.
//

import Foundation

struct Shopping: Decodable {
    let total: Int
    let items: [ShoppingDetail]
}

struct ShoppingDetail: Decodable {
    let title: String
    let image: String
    let price: String
    let mallName: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case image
        case price = "lprice"
        case mallName
    }

}


// 질문: 빈 배열을 이렇게 전역변수로 달랑 두는게 괜찮은지 (내부에서 따로 또 생성해서 하고싶지 않아서 이렇게 했는데...)
var list: [ShoppingDetail] = []
