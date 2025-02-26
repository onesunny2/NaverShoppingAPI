//
//  WishProduct.swift
//  WSShopping
//
//  Created by Lee Wonsun on 2/26/25.
//

import Foundation

struct WishProduct: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let date = Date()
}
