//
//  Observar.swift
//  WSShopping
//
//  Created by Lee Wonsun on 2/6/25.
//

import Foundation

//final class Observable<T> {
//    
//    var closure: ((T) -> ())?
//    
//    var value: T {
//        didSet {
//            closure?(value)
//        }
//    }
//    
//    init(_ value: T) {
//        self.value = value
//    }
//    
//    // 먼저 설정된 값부터 감시하는 메서드
//    func bind(_ closure: @escaping (T) -> ()) {
//        closure(value)
//        self.closure = closure
//    }
//    
//    // 다음 행동이 일어난 후부터 감시하는 메서드
//    func lazyBind(_ closure: @escaping (T) -> ()) {
//        self.closure = closure
//    }
//}
