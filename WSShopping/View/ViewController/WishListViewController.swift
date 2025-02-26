//
//  WishListViewController.swift
//  WSShopping
//
//  Created by Lee Wonsun on 2/26/25.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class WishListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
 

}

extension WishListViewController {
    
    private func configure() {
        view.backgroundColor = .white
        
        navigationItem.title = "위시리스트"
    }
}
