//
//  StrokeButton.swift
//  WSShopping
//
//  Created by Lee Wonsun on 1/15/25.
//

import UIKit

class StrokeButton: UIButton {
    
    static let titleList = ["정확도", "날짜순", "가격높은순", "가격낮은순"]
    
    func configButton(title: String, isTapped: Bool) {
        
        let container = AttributeContainer().font(.systemFont(ofSize: 14, weight: .regular))
        
        var config = Configuration.filled()
        config.cornerStyle = .medium
        config.title = title
        config.attributedTitle = AttributedString(title, attributes: container)
        config.baseBackgroundColor = isTapped ? .label : .systemBackground
        config.background.strokeColor = .label
        config.background.strokeWidth = 1
        config.baseForegroundColor = isTapped ? .systemBackground : .label
        
        self.configuration = config
    }

    init(title: String, isTapped: Bool) {
        super.init(frame: .zero)
        configButton(title: title, isTapped: isTapped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
