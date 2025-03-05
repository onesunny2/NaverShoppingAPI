//
//  WishFolderViewController.swift
//  WSShopping
//
//  Created by Lee Wonsun on 3/5/25.
//

import UIKit
import SnapKit

fileprivate enum FolderSection: CaseIterable {
    case first
}

final class WishFolderViewController: UIViewController {
    
    private let repository: BaseRepository = RealmRepository()
    private lazy var folderList = Array(repository.fetchAll(WishFolderTable.self))
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionviewLayout())
    private var dataSource: UICollectionViewDiffableDataSource<FolderSection, WishFolderTable>?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureDataSource()
        updateSnapshot()
    }
    
    private func configureDataSource() {
        
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, WishFolderTable> { cell, indexPath, item in
            
            var content = UIListContentConfiguration.accompaniedSidebarSubtitleCell()
            content.text = item.name
            content.textProperties.color = .systemPink
            content.textProperties.font = .systemFont(ofSize: 18, weight: .semibold)
            content.secondaryText = "\(item.content.count)개"
            content.secondaryTextProperties.color = .black
            content.secondaryTextProperties.font = .systemFont(ofSize: 15, weight: .medium)
            content.image = UIImage(systemName: "number")
            content.imageProperties.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 15)
            content.imageProperties.tintColor = .black
            content.prefersSideBySideTextAndSecondaryText = true
            
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listAccompaniedSidebarCell()
            backgroundConfig.backgroundColor = .systemMint.withAlphaComponent(0.1)
            backgroundConfig.strokeColor = .darkGray
            backgroundConfig.strokeWidth = 1
            
            cell.backgroundConfiguration = backgroundConfig
        }

        // MARK: DataSource
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: {
                collectionView,
                indexPath,
                itemIdentifier in
                
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: registration,
                    for: indexPath,
                    item: itemIdentifier
                )
                
                return cell
            }
        )
    }
 
    private func updateSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<FolderSection, WishFolderTable>()
        snapshot.appendSections(FolderSection.allCases)
        snapshot.appendItems(folderList, toSection: FolderSection.first)
        
        dataSource?.apply(snapshot)
    }
}

extension WishFolderViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = folderList[indexPath.item]
        
        // TODO: 위시리스트로 push
        let vc = WishListViewController(folderData: data)
        
        vc.wishList = Array(data.content)
        vc.popVC = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WishFolderViewController {
    private func collectionviewLayout() -> UICollectionViewLayout {
        
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
    
    private func configureView() {
        view.backgroundColor = .white
        navigationItem.title = "Wish Folder"
        navigationItem.backButtonTitle = ""
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
