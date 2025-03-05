//
//  WishFolderTable.swift
//  WSShopping
//
//  Created by Lee Wonsun on 3/5/25.
//

import Foundation
import RealmSwift

final class WishFolderTable: Object {
    
    @Persisted var id: ObjectId
    @Persisted var name: String
    
    @Persisted var content: List<WishListTable>
    
    convenience init(name: String) {
        self.init()
        
        self.id = id
        self.name = name
    }
}

enum FolderName: String, CaseIterable {
    case 화장품
    case 맛집
    case 버킷리스트
    case 블로그작성
}
