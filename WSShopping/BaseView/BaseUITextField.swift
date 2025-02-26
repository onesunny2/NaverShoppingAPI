//
//  BaseUITextField.swift
//  WSShopping
//
//  Created by Lee Wonsun on 2/26/25.
//

import UIKit

final class BaseUITextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let placeHolder = "사고싶은 물건을 입력해보세요!"
        
        self.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.keyboardType = .default
        self.clearButtonMode = .whileEditing
        self.borderStyle = .roundedRect
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.backgroundColor = .systemGray6.withAlphaComponent(0.5)
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
