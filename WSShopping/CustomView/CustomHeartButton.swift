//
//  CustomHeartButton.swift
//  WSShopping
//
//  Created by Lee Wonsun on 2/27/25.
//

import UIKit

final class CustomHeartButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            self.configuration = isSelected ? configButton(.like) : configButton(.unlike)
        }
    }
    
    init(_ value: Bool) {
        super.init(frame: .zero)
        isSelected = value
    }
    
    private func configButton(_ status: Status) -> UIButton.Configuration {
        
        var config = UIButton.Configuration.filled()
        
        config.image = UIImage(systemName: status.imgName)
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .systemPink
        
        return config
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isSelected.toggle()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomHeartButton {
    
    enum Status: String {
        case like = "heart.fill"
        case unlike = "heart"
        
        var imgName: String {
            return self.rawValue
        }
    }
}
