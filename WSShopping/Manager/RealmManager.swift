//
//  RealmManager.swift
//  WSShopping
//
//  Created by Lee Wonsun on 3/4/25.
//

import Foundation
import RealmSwift

final class RealmManager: BaseRealm {
    
    static let shared = RealmManager()
    private init() { }
    
    private let realm = try! Realm()
    
    // 파일 경로 확인
    func checkDefaultRealmLocation() {
        print("Realm 저장위치 ==", realm.configuration.fileURL ?? "")
    }
    
    // create
    func create<T: Object>(_ object: T) {
        
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("create error")
        }
    }
    
    // Read
    func read<T: Object>(_ object: T.Type) -> Results<T> {
        return realm.objects(object)
    }
    
    // Update
    func update<T: Object>(_ object: T.Type, value: [String: Any])  {
        
        do {
            try realm.write {
                realm.create(object, value: value, update: .modified)
            }
        } catch {
            print("realm update error")
        }
    }
    
    // Delete
    func delete<T: Object>(_ object: T) {
        
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("realm delete error")
        }
    }
    
    // Sort
    func sort<T: Object>(_ object: T.Type, keyPath: String, ascending: Bool) -> Results<T> {
        return realm.objects(object).sorted(byKeyPath: keyPath, ascending: ascending)
    }
}
