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
        
        defaultImage.snp.makeConstraints {
            $0.centerY.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(60)
            $0.height.equalTo(defaultImage.snp.width).multipliedBy(1.3)
        }
        
        defaultLabel.snp.makeConstraints {
            $0.centerX.equalTo(defaultImage)
            $0.top.equalTo(defaultImage.snp.bottom).offset(-20)
            $0.width.equalTo(300)
        }
    }
    
    func configView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "원선's 쇼핑치링치링"
        
        searchbar.searchBarStyle = .minimal
        searchbar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        
        defaultImage.image = UIImage(named: "shopping")
        defaultImage.contentMode = .scaleAspectFit
        
        defaultLabel.text = "이것도 사고 저것도 살래 :>"
        defaultLabel.textColor = .label
        defaultLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        defaultLabel.textAlignment = .center
        defaultLabel.numberOfLines = 1
    }
    
    
}
