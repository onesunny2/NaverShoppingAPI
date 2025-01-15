//
//  StrokeButton.swift
//  WSShopping
//
//  Created by Lee Wonsun on 1/15/25.
//

import UIKit

//class BaseButton: UIView {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//}

class StrokeButton: UIButton {
    
    static let titleList = ["정확도", "날짜순", "가격높은순", "가격낮은순"]

    init(title: String, isTapped: Bool) {
        super.init(frame: .zero)
        
        let container = AttributeContainer().font(.systemFont(ofSize: 14, weight: .regular))
        
        configuration = .filled()
        configuration?.cornerStyle = .medium
        configuration?.title = title
        configuration?.attributedTitle = AttributedString(title, attributes: container)
        configuration?.baseForegroundColor = isTapped ? .black : .white
        configuration?.baseBackgroundColor = isTapped ? .white : .black
        configuration?.background.strokeColor = .white
        configuration?.background.strokeWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
