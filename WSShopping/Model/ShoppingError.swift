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
    case statudError(code: Int, message: String)
    
    var title: String {
        switch self {
        case .invalidURL:
            return "URL Error"
        case .unknownResponse:
            return "unknownedResponse Error"
        case let .statudError(code, _):
            return "에러코드: \(code)"
        }
    }
    
    var message: String {
        switch self {
        case .invalidURL:
            return "잘못된 URL 접근입니다."
        case .unknownResponse:
            return "unknownedResponse Error"
        case let .statudError(_, message):
            return "\(message)"
        }
    }
}
