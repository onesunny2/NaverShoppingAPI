//
//  SearchResultViewController.swift
//  WSShopping
//
//  Created by Lee Wonsun on 1/15/25.
//

import UIKit
import Alamofire
import SnapKit

class SearchResultViewController: UIViewController {
    
    lazy var resultCountLabel = ResultLabel(title: resultCount, size: 15, weight: .bold, color: .systemGreen)
    var filteringButtons: [UIButton] = []
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    lazy var filterStackview = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.distribution = .equalSpacing
        stackview.alignment = .leading
        
        return stackview
    }()
    
    var nvtitle = ""
    var resultCount = "222,222,222개의 검색결과"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = StrokeButton.titleList
        let isTapped = [true, false, false, false]
        
        for index in 0...3 {
            filteringButtons.append(StrokeButton(title: title[index], isTapped: isTapped[index]))
        }
        
        print(filteringButtons.description)

        configHierarchy()
        configLayout()
        configView()
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        
        let sectionInsect: CGFloat = 10
        let cellSpacing: CGFloat = 10
        let cellWidth: CGFloat = (UIScreen.main.bounds.width - (sectionInsect * 2 + cellSpacing)) / 2
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.5)
        layout.sectionInset = UIEdgeInsets(top: 8, left: sectionInsect, bottom: 8, right: sectionInsect)
        
        return layout
    }

}

// MARK: - collectionView 설정
extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        
        cell.thumnailImageView.image = UIImage(named: "zzamong")
        cell.thumnailImageView.contentMode = .scaleAspectFill
        
        return cell
    }
    
    
}

// MARK: - 레이아웃 및 속성 설정
extension SearchResultViewController: ShoppingConfigure {
    func configHierarchy() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(resultCountLabel)
        view.addSubview(filterStackview)
        for index in 0...3 {
            filterStackview.addArrangedSubview(filteringButtons[index])
        }
        view.addSubview(collectionView)
        
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.id)
    }
    
    func configLayout() {
        resultCountLabel.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.width.equalTo(UIScreen.main.bounds.size.width - 30)
        }
        
        filterStackview.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.width.equalTo(UIScreen.main.bounds.size.width * 0.85)
            $0.height.equalTo(35)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(filterStackview.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = nvtitle
    }
    
    
}
