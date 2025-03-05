//
//  BaseRepository.swift
//  WSShopping
//
//  Created by Lee Wonsun on 3/5/25.
//

import Foundation
import RealmSwift

protocol BaseRepository: AnyObject, FolderRepository {
    func getFileURL()
    func fetchAll<T: Object>(_ object: T.Type) -> Results<T>
    func createItem<T: Object>(_ object: T)
    func deleteItem<T: Object>(_ object: T)
    func updateItem<T: Object>(_ object: T.Type, value: [String: Any])
}
