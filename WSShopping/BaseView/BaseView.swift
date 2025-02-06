//
//  BaseView.swift
//  WSShopping
//
//  Created by Lee Wonsun on 1/17/25.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configHierarchy()
        configLayout()
        configView()
    }
    
    func configHierarchy() { }
    func configLayout() { }
    func configView() { }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
