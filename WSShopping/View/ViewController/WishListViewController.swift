//
//  WishListViewController.swift
//  WSShopping
//
//  Created by Lee Wonsun on 2/26/25.
//

import UIKit
import SnapKit

fileprivate enum WishSection: CaseIterable {
    case first
}

final class WishListViewController: UIViewController, UITextFieldDelegate {
    
    private let repository: BaseRepository = RealmRepository()
    
    private let textfield = BaseUITextField()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionviewLayout())
    
    private var dataSource: UICollectionViewDiffableDataSource<WishSection, WishListTable>?
    
    var wishList: [WishListTable] = []
    var folderData: WishFolderTable  // 네비게이션 타이틀, id 전달 위함
    
    var popVC: (() -> ())?
    
    init(folderData: WishFolderTable) {
        self.folderData = folderData
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureDataSource()
        updateSnapshot()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        popVC?()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        view.endEditing(true)
    }
    
    @objc private func tappedTextfieldReturn(_ textfield: UITextField) {
        
        guard let keyword = textfield.text else { return }
        
        let product = WishListTable(wishName: keyword, regDate: Date())
        wishList.append(product)
        updateSnapshot()
        
        let folder = repository.fetchAll(WishFolderTable.self)
            .filter { $0.id == self.folderData.id }.first!
        
        repository.createItemInFolder(product, folder: folder)
        
        textfield.text = ""
    }
 
    private func configureDataSource() {
        
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, WishListTable> { cell, indexPath, item in
            
            var content = UIListContentConfiguration.accompaniedSidebarSubtitleCell()
            content.text = item.wishName
            content.textProperties.color = .label
            content.textProperties.font = .systemFont(ofSize: 16, weight: .semibold)
            content.secondaryText = item.regDate.dateToString()
            content.secondaryTextProperties.color = .darkGray
            content.secondaryTextProperties.font = .systemFont(ofSize: 13, weight: .medium)
            content.image = UIImage(systemName: "square")
            content.imageProperties.tintColor = .systemPink
            content.prefersSideBySideTextAndSecondaryText = true
            
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listAccompaniedSidebarCell()
            backgroundConfig.backgroundColor = .systemGray6.withAlphaComponent(0.5)
            backgroundConfig.strokeColor = .systemMint
            backgroundConfig.strokeWidth = 1
            
            cell.backgroundConfiguration = backgroundConfig
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
    }
    
    private func updateSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<WishSection, WishListTable>()
        snapshot.appendSections(WishSection.allCases)
        snapshot.appendItems(wishList, toSection: WishSection.first)
        
        dataSource?.apply(snapshot)
    }
}

extension WishListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let deletedItem = wishList[indexPath.item]
        wishList.remove(at: indexPath.item)
        
        repository.deleteItem(deletedItem)
        
        updateSnapshot()
    }
}

extension WishListViewController {
    
    // MARK: collectionview layout
    private func collectionviewLayout() -> UICollectionViewLayout {
        
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
    
    private func configureView() {
        view.backgroundColor = .white
        navigationItem.title = folderData.name
        collectionView.keyboardDismissMode = .onDrag
        textfield.delegate = self
        collectionView.delegate = self
        
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
        
        textfield.addTarget(self, action: #selector(tappedTextfieldReturn), for: .editingDidEndOnExit)
    }
}
