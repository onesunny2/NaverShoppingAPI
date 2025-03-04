//
//  WishRealmListViewController.swift
//  WSShopping
//
//  Created by Lee Wonsun on 3/4/25.
//

import UIKit
import SnapKit

final class WishRealmListViewController: UIViewController {
    
    private let searchbar = UISearchBar()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configHierarchy()
        configLayout()
        configView()
    }
 
}

extension WishRealmListViewController: ShoppingConfigure {
    
    func configHierarchy() {
        view.addSubview(searchbar)
        view.addSubview(collectionView)
    }
    
    func configLayout() {
        searchbar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchbar.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view)
        }
    }
    
    func configView() {
        view.backgroundColor = .white
        
        navigationItem.title = "좋아요 목록"
        
        let sortMenu = UIMenu(title: "정렬하기", options: .displayInline, children: configMenuItems())
        let rightBarbuttonItem = UIBarButtonItem(title: "정렬", primaryAction: nil, menu: sortMenu)
        navigationItem.rightBarButtonItem = rightBarbuttonItem
        
        searchbar.searchBarStyle = .minimal
        searchbar.placeholder = "좋아요를 누른 상품을 검색해 보세요"
        
        collectionView.backgroundColor = .clear
    }
    
    private func configMenuItems() -> [UIAction] {
        return [
            UIAction(title: "이름순", handler: { _ in print("이름순") }),
            UIAction(title: "가격순", handler: { _ in print("가격순") }),
            UIAction(title: "최신순", handler: { _ in print("최신순") })
        ]
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        
        let sectionInsect: CGFloat = 10
        let cellSpacing: CGFloat = 15
        let cellWidth: CGFloat = (UIScreen.main.bounds.width - (sectionInsect * 2 + cellSpacing)) / 2
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.5)
        layout.sectionInset = UIEdgeInsets(top: 2, left: sectionInsect, bottom: 2, right: sectionInsect)
        
        return layout
    }
}
