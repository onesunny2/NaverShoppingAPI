//
//  WishListTable.swift
//  WSShopping
//
//  Created by Lee Wonsun on 3/5/25.
//

import Foundation
import RealmSwift

final class WishListTable: Object {
    
    @Persisted var id: ObjectId
    @Persisted var wishName: String
    @Persisted var regDate: Date
    
    @Persisted(originProperty: "content") var folder: LinkingObjects<WishFolderTable>
    
    convenience init(wishName: String, regDate: Date) {
        self.init()
        
        self.id = id
        self.wishName = wishName
        self.regDate = regDate
    }
}
