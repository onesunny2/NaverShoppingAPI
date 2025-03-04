//
//  WishRealmList.swift
//  WSShopping
//
//  Created by Lee Wonsun on 3/4/25.
//

import Foundation
import RealmSwift

final class WishRealmList: Object {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted var imageURL: String
    @Persisted var mallName: String
    @Persisted var title: String
    @Persisted var price: Int
    @Persisted var isLiked: Bool
    
    convenience init(id: String, imageURL: String, mallName: String, title: String, price: Int, isLiked: Bool) {
        self.init()
        self.id = id
        self.imageURL = imageURL
        self.mallName = mallName
        self.title = title
        self.price = price
        self.isLiked = isLiked
    }
}
