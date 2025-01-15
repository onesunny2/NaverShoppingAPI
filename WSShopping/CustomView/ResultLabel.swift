//
//  ResultLabel.swift
//  WSShopping
//
//  Created by Lee Wonsun on 1/15/25.
//

import UIKit

class BaseLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ResultLabel: BaseLabel {
    
    init(title: String, size: CGFloat, weight: UIFont.Weight, color: UIColor, line: Int = 1) {
        super.init(frame: .zero)
        
        text = title
        textAlignment = .left
        font = .systemFont(ofSize: size, weight: weight)
        textColor = color
        numberOfLines = line
    }
}
