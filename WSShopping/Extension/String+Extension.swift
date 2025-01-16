//
//  String+Extension.swift
//  WSShopping
//
//  Created by Lee Wonsun on 1/16/25.
//

import Foundation

extension String {
    var escapingHTML: String {
        let pattern = #"<b>|<\/b>"#
        
        return self.replacingOccurrences(of: pattern, with: "", options: .regularExpression, range: nil)
    }
}
