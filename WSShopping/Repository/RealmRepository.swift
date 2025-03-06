//
//  RealmRepository.swift
//  WSShopping
//
//  Created by Lee Wonsun on 3/5/25.
//

import Foundation
import RealmSwift

final class RealmRepository: BaseRepository {
    
    private let realm = try! Realm()
    
    func getFileURL() {
        print(realm.configuration.fileURL ?? "")
    }
    
    func fetchAll<T: Object>(_ object: T.Type) -> Results<T> {
        return realm.objects(object.self)
    }
    
    func createItem<T: Object>(_ object: T) {  // folder 테이블 상관없이 레코드 추가
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("==realm create 실패==")
        }
    }
    
    func deleteItem<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("==realm delete 실패==")
        }
    }
    
    func updateItem<T: Object>(_ object: T.Type, value: [String : Any]) {
        do {
            try realm.write {
                realm.create(object.self, value: value, update: .modified)
            }
        } catch {
            print("==realm update 실패==")
        }
    }
    
    // TODO: 질문 - Generic 내에 특정 타입에 대한 메서드...
    func createItemInFolder(_ object: WishListTable, folder: WishFolderTable) {  // folder의 content에 담기위한 메서드
        do {
            try realm.write {
                folder.content.append(object)
            }
        } catch {
            print("==realm createFolder 실패==")
        }
    }
}
