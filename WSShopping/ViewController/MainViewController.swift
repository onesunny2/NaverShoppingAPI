//
//  MainViewController.swift
//  WSShopping
//
//  Created by Lee Wonsun on 1/15/25.
//

import UIKit
import SnapKit

class MainViewController: UIViewController, UISearchBarDelegate {
    
    let searchbar = UISearchBar()
    let defaultImage = UIImageView()
    let defaultLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configHierarchy()
        configLayout()
        configView()
    }

}

extension MainViewController: ShoppingConfigure {
    func configHierarchy() {
        searchbar.delegate = self
    
        view.addSubview(searchbar)
        view.addSubview(defaultImage)
        view.addSubview(defaultLabel)
    }
    
    func configLayout() {
        searchbar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
    }
    
    func configView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "원선's 쇼핑치링치링"
        
        searchbar.searchBarStyle = .minimal
        searchbar.placeholder = "브랜드, 상품, 프로필, 태그 등"
    }
    
    
}
