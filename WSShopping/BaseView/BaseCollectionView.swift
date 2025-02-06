//
//  BaseCollectionViewCell.swift
//  WSShopping
//
//  Created by Lee Wonsun on 1/17/25.
//

import UIKit
import SnapKit

class BaseCollectionView: BaseView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        
        let sectionInsect: CGFloat = 10
        let cellSpacing: CGFloat = 15
        let cellWidth: CGFloat = (UIScreen.main.bounds.width - (sectionInsect * 2 + cellSpacing)) / 2
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.5)
        layout.sectionInset = UIEdgeInsets(top: 8, left: sectionInsect, bottom: 8, right: sectionInsect)
        
        return layout
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func scrollToUp() {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    
    override func configHierarchy() {
        self.addSubview(collectionView)
    }
    
    override func configLayout() {
        collectionView.snp.makeConstraints {
//            $0.top.equalTo(filterStackview.snp.bottom)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        backgroundColor = .clear
        
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.id)
    }
}

//extension BaseCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 190
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    }
//    
//    
//}
