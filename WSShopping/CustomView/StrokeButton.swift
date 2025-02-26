//
//  StrokeButton.swift
//  WSShopping
//
//  Created by Lee Wonsun on 1/15/25.
//

import UIKit

final class StrokeButton: UIButton {
    
    override var isSelected: Bool {
        didSet {

            self.configuration?.baseBackgroundColor = isSelected ? .label : .systemBackground
            self.configuration?.baseForegroundColor = isSelected ? .systemBackground : .label

        }
    }

    init(sort: Sort, isSelected: Bool) {
        super.init(frame: .zero)
        
        self.isSelected = isSelected
        configButton(sort: sort)
    }
    
    private func configButton(sort: Sort) {
        
        let container = AttributeContainer().font(.systemFont(ofSize: 14, weight: .regular))
        
        var config = Configuration.filled()
        config.cornerStyle = .medium
        config.attributedTitle = AttributedString(sort.rawValue, attributes: container)
        config.baseBackgroundColor = isSelected ? .label : .systemBackground
        config.background.strokeColor = .label
        config.background.strokeWidth = 1
        config.baseForegroundColor = isSelected ? .systemBackground : .label
        
        self.configuration = config
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        isSelected.toggle()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    
enum Sort: String, CaseIterable {
    case 정확도
    case 날짜순
    case 가격높은순
    case 가격낮은순
    
    var query: String {
        switch self {
        case .정확도: return "sim"
        case .날짜순: return "date"
        case .가격높은순: return "dsc"
        case .가격낮은순: return "asc"
        }
    }
}

