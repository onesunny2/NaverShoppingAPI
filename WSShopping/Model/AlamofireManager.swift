//
//  AlamofireManager.swift
//  WSShopping
//
//  Created by Lee Wonsun on 1/16/25.
//

import UIKit
import Alamofire

final class AlamofireManager {
    
    static let shared = AlamofireManager()
    
    private init() { }
    
    func callRequest<T: Decodable>(_ type: T.Type, api: ApiUrl,  completionHandler: @escaping (Result<T, AFError>) -> ()) {
        
        AF.request(
            api.endPoint,
            method: api.method,
            parameters: api.parameters,
            encoding: URLEncoding(destination: .queryString),
            headers: api.header
        ).responseDecodable(of: T.self) { response in
            
            switch response.result {
            case .success(let value):
                completionHandler(.success(value))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
    }
}

extension AlamofireManager {
    
    enum ApiUrl {
        case shopping(keyword: String, sortName: String, start: Int)
        
        var method: HTTPMethod {
            return .get
        }
        
        var header: HTTPHeaders {
            return ["X-Naver-Client-Id": APIKey.clientID, "X-Naver-Client-Secret": APIKey.clientSecret]
        }
        
        var baseUrl: String {
            return "https://openapi.naver.com/v1"
        }
        
        var endPoint: String {
            return baseUrl + "search/shop.json"
        }
        
        var parameters: Parameters {
            switch self {
            case let .shopping(keyword, sortName, start):
                return ["query": keyword, "display": 30, "sort": sortName, "start": start]
            }
        }
    }
}
