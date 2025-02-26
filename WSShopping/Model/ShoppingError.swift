//
//  ShoppingError.swift
//  WSShopping
//
//  Created by Lee Wonsun on 2/26/25.
//

import Foundation

enum ShoppingError: Error {
    case invalidURL
    case unknownResponse
    case statudError(code: Int)
    
    var message: String {
        switch self {
        case .invalidURL:
            return "잘못된 URL 접근입니다."
        case .unknownResponse:
            return "unknownedResponse Error"
        case .statudError(let code):
            return "error \(code): status Error"
        }
    }
}
