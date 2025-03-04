//
//  BaseRealm.swift
//  WSShopping
//
//  Created by Lee Wonsun on 3/4/25.
//

import Foundation
import RealmSwift

protocol BaseRealm {
    func read<T: Object>(_ object: T.Type) -> Results<T>
    func write<T: Object>(_ object: T)
    func delete<T: Object>(_ object: T)
    func sort<T: Object>(_ object: T.Type, keyPath: String, ascending: Bool) -> Results<T>
}
