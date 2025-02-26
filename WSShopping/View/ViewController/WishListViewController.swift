//
//  WishListViewController.swift
//  WSShopping
//
//  Created by Lee Wonsun on 2/26/25.
//

import UIKit
import SnapKit

fileprivate enum Section: CaseIterable {
    case first
}

final class WishListViewController: UIViewController {
    
    private let textfield = BaseUITextField()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionviewLayout())
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, WishProduct>?
    
    private var wishList: [WishProduct] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureDataSource()
        updateSnapshot()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        view.endEditing(true)
    }
 
    private func configureDataSource() {
        
        var registration = UICollectionView.CellRegistration<UICollectionViewListCell, WishProduct> { cell, indexPath, item in
            
            var content = UIListContentConfiguration.accompaniedSidebarSubtitleCell()
            content.text = item.name
            content.textProperties.color = .label
            content.textProperties.font = .systemFont(ofSize: 16, weight: .semibold)
            content.secondaryText = item.date.dateToString()
            content.secondaryTextProperties.color = .darkGray
            content.secondaryTextProperties.font = .systemFont(ofSize: 13, weight: .medium)
            content.image = UIImage(systemName: "checkmark.square")
            content.prefersSideBySideTextAndSecondaryText = true
            
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listAccompaniedSidebarCell()
            
            cell.backgroundConfiguration = backgroundConfig
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
    }
    
    private func updateSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, WishProduct>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(wishList, toSection: Section.first)
        
        dataSource?.apply(snapshot)
    }
}

extension WishListViewController {
    
    // MARK: collectionview layout
    private func collectionviewLayout() -> UICollectionViewLayout {
        
        var config = UICollectionLayoutListConfiguration(appearance: .sidebar)
        config.backgroundColor = .systemGray6
        config.headerMode = .firstItemInSection
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
    
    private func configureView() {
        view.backgroundColor = .white
        navigationItem.title = "위시리스트"
        collectionView.keyboardDismissMode = .onDrag
        
        view.addSubview(textfield)
        textfield.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(textfield.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
