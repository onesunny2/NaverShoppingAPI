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
    
    let resultCountLabel = UILabel()
    var filteringButtons: [UIButton] = []
//    let collectionView = UICollectionView()
    lazy var filterStackview = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.distribution = .equalSpacing
        stackview.alignment = .leading
        
        return stackview
    }()
    
    var nvtitle = ""

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

}

// MARK: - collectionView 설정
//extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//    
//    
//}

// MARK: - 레이아웃 및 속성 설정
extension SearchResultViewController: ShoppingConfigure {
    func configHierarchy() {
//        collectionView.delegate = self
//        collectionView.dataSource = self
        
        view.addSubview(resultCountLabel)
        view.addSubview(filterStackview)
        for index in 0...3 {
            filterStackview.addArrangedSubview(filteringButtons[index])
        }
//        view.addSubview(collectionView)
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
    }
    
    func configView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = nvtitle
        
        resultCountLabel.text = "22,222,222개의 검색 결과"
        resultCountLabel.textColor = .systemGreen
        resultCountLabel.font = .systemFont(ofSize: 15, weight: .bold)
        resultCountLabel.numberOfLines = 1
        resultCountLabel.textAlignment = .left
    }
    
    
}
