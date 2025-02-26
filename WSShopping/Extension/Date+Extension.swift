//
//  Date+Extension.swift
//  WSShopping
//
//  Created by Lee Wonsun on 2/26/25.
//

import Foundation

extension Date {
    
    func dateToString() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy년 MM월 dd일"
        let result = dateFormat.string(from: self)
        
        return result
    }
}
