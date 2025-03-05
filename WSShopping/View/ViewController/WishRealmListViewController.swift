//
//  WishRealmListViewController.swift
//  WSShopping
//
//  Created by Lee Wonsun on 3/4/25.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RealmSwift

/*
 데이터가 false로는 바뀌는데 왜 안빠지는지
 */

final class WishRealmListViewController: UIViewController {
    
    private let realm = RealmManager.shared
    var list: Results<WishRealmList>!
    var currentLists: [WishRealmList] = []
    
    private let disposeBag = DisposeBag()
    
    private let searchbar = UISearchBar()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list = realm.read(WishRealmList.self)
        currentLists = list.filter { $0.isLiked }
        
        configHierarchy()
        configLayout()
        configView()
        
        bind()
    }
    
    private func bind() {
        
//        var newList = list?.filter { $0.isLiked }
 
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.id)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchbar.delegate = self
        
       /* BehaviorRelay(value: newList)
            .compactMap { $0 }
            .bind(to: collectionView.rx.items(
                cellIdentifier: SearchResultCollectionViewCell.id,
                cellType: SearchResultCollectionViewCell.self
            )) { item, element, cell in
                
                cell.configureCell(
                    url: element.imageURL,
                    mallName: element.mallName,
                    title: element.title,
                    price: String(element.price),
                    id: element.id
                )
                
                // MARK: reloadData가 안먹히는 이유
                cell.tappedHeart = {
                    self.collectionView.reloadData()
                }
            }
            .disposed(by: disposeBag)
        
        // MARK:
        searchbar.rx.text.orEmpty
            .map { text in
                let value = self.list?.where {
                    $0.title.contains(text, options: .caseInsensitive)
                }.filter { $0.isLiked }
                
                return value
            }
            .bind(with: self) { this, value in
                newList = value
                this.collectionView.reloadData()
            }
            .disposed(by: disposeBag) */
    }
 
}

extension WishRealmListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = currentLists[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(url: data.imageURL, mallName: data.mallName, title: data.title, price: String(data.price), id: data.id)
        
        cell.tappedHeart = {
            // MARK: Results 타입을 사용하는데 왜 바로 데이터가 안바뀔까
            self.currentLists = self.list.filter { $0.isLiked }
            self.collectionView.reloadData()
        }
        
        return cell
    }
}

extension WishRealmListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard searchText.count > 0 else {
            currentLists = list.filter { $0.isLiked }
            collectionView.reloadData()
            return
        }
        
        currentLists = list.filter {
            $0.title.contains(searchText) ||
            $0.mallName.contains(searchText)
        }
        
        collectionView.reloadData()
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
