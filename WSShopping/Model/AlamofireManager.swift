//
//  AlamofireManager.swift
//  WSShopping
//
//  Created by Lee Wonsun on 1/16/25.
//

import UIKit
import Alamofire

class AlamofireManager {
    
    static let shared = AlamofireManager()
    
    private init() { }
    
    func getShoppingResult(keyword: String, sortName: String, start: Int, completionHandler: @escaping (Shopping) -> (Void)) {
        
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(keyword)&display=30&sort=\(sortName)&start=\(start)"
        
        let headers = HTTPHeaders(["X-Naver-Client-Id": APIKey.clientID, "X-Naver-Client-Secret": APIKey.clientSecret])
        
        AF.request(url, method: .get, headers: headers).responseString { value in
            dump(value)
        }
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: Shopping.self) { response in
            
            switch response.result {
            case .success(let value):
                completionHandler(value)
                
            case .failure(let error):
                print("error", error)
            }
        }
    }
}
