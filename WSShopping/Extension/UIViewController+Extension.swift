//
//  UIViewController+Extension.swift
//  WSShopping
//
//  Created by Lee Wonsun on 1/17/25.
//

import UIKit

extension UIViewController {
    
    func alertWordCount(message: String, completionHandler: @escaping () -> UIAlertAction) {
        
        let message = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let okay = completionHandler()
        
        message.addAction(okay)
        
        present(message, animated: true)
        
    }
    
    func alertError(message: String) {
        let message = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "확인", style: .cancel)
        message.addAction(okay)
        
        present(message, animated: true)
    }
}
