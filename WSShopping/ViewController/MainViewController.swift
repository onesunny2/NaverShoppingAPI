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
    
    let homecontent = HomeContent(isValid: true)

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
            $0.top.equalTo(defaultImage.snp.bottom).offset(homecontent.isValid ? -20 : -60)
            $0.width.equalTo(300)
        }
    }
    
    func configView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = HomeContent.title
        
        searchbar.searchBarStyle = .minimal
        searchbar.placeholder = HomeContent.placeholder
        
        defaultImage.image = UIImage(named: homecontent.isValidCheck(content: Contents.imageName))
        defaultImage.contentMode = .scaleAspectFit
        
        defaultLabel.text = homecontent.isValidCheck(content: Contents.labelText)
        defaultLabel.textColor = .label
        defaultLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        defaultLabel.textAlignment = .center
        defaultLabel.numberOfLines = 1
    }
    
    
}
