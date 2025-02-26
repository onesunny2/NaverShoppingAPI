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
    let link: String
    let image: String
    let price: String
    let mallName: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case link
        case image
        case price = "lprice"
        case mallName
    }

}

