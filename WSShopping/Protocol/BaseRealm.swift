//
//  BaseRealm.swift
//  WSShopping
//
//  Created by Lee Wonsun on 3/4/25.
//

import Foundation
import RealmSwift

protocol BaseRealm: AnyObject {
    func create<T: Object>(_ object: T)
    func read<T: Object>(_ object: T.Type) -> Results<T>
    func delete<T: Object>(_ object: T)
    func update<T: Object>(_ object: T.Type, value: [String: Any])
    func sort<T: Object>(_ object: T.Type, keyPath: String, ascending: Bool) -> Results<T>
}
