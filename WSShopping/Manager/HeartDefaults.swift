//
//  HeartDefaults.swift
//  WSShopping
//
//  Created by Lee Wonsun on 2/27/25.
//

import Foundation
import RxCocoa
import RxSwift

@propertyWrapper
struct HeartDefaults<T> {
    
    let key: SavingInfo
    let empty: T
    
    init(key: SavingInfo, empty: T) {
        self.key = key
        self.empty = empty
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key.id) as? T ?? empty
        }
        set {
            UserDefaults.standard.set(newValue as T, forKey: key.id)
        }
    }
    
    var projectedValue: Observable<T> {
        return UserDefaults.standard.rx.observe(
            T.self,
            key.id,
            options: [.initial, .new]
        )
        .map { $0 ?? empty }
    }
}

// 외부에서 호출해서 사용 할 푸링디폴트의 key 값들
enum SavingInfo {
    case 좋아요(id: String)
    
    var id: String {
        switch self {
        case let .좋아요(id): return id
        }
    }

    static func reset() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}

