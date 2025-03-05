//
//  FolderRepository.swift
//  WSShopping
//
//  Created by Lee Wonsun on 3/5/25.
//

import Foundation
import RealmSwift

protocol FolderRepository: AnyObject {
    func createItemInFolder(_ object: WishListTable, folder: WishFolderTable)
}
