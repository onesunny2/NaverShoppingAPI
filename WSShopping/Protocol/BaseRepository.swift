//
//  BaseRepository.swift
//  WSShopping
//
//  Created by Lee Wonsun on 3/5/25.
//

import Foundation
import RealmSwift

protocol BaseRepository: AnyObject {
    func getFileURL()
    func fetchAll<T: Object>() -> Results<T>
    func createItem()
    func deleteItem<T: Object>(_ object: T)
    func updateItem<T: Object>(_ object: T.Type, value: [String: Any])
}
