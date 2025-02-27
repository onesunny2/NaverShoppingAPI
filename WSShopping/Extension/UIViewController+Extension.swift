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
    
    func alertError(title: String, message: String) {
        let message = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "확인", style: .cancel) { [weak self] _ in
            guard let self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        message.addAction(okay)
        
        present(message, animated: true)
    }
}
