//
//  SearchResultViewController.swift
//  WSShopping
//
//  Created by Lee Wonsun on 1/15/25.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit

class SearchResultViewController: UIViewController {
    
    lazy var resultCountLabel = ResultLabel(title: "", size: 15, weight: .bold, color: .systemGreen)
    var filteringButtons: [UIButton] = []
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    lazy var filterStackview = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.distribution = .equalSpacing
        stackview.alignment = .leading
        
        return stackview
    }()
    
    var start = 1
    var keyword = ""
    var sortName = "sim"
    var total = 0
    var isEnd = false
    var list: [ShoppingDetail] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    let buttonTitle = StrokeButton.titleList
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0...3 {

            if index == 0 {
                filteringButtons.append(StrokeButton(title: buttonTitle[index], isTapped: true))
            } else {
                filteringButtons.append(StrokeButton(title: buttonTitle[index], isTapped: false))
            }
            
            filteringButtons[index].tag = index
        }

        configHierarchy()
        configLayout()
        configView()
        
        callRequest()

    }
    
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
    
    func callRequest() {
        
        AlamofireManager.shared.getShoppingResult(keyword: keyword, sortName: sortName, start: start) { value in

            if self.start == 1 {
                self.total = value.total
                self.resultCountLabel.text = String(self.total.formatted()) + "개의 검색결과"
                self.list = value.items
            } else {
                self.list.append(contentsOf: value.items)
            }
        }
        
    }
    
    @objc
    func filteringButtonTapped(button: UIButton) {
 
        guard let title = button.titleLabel?.text else { return }
        
        switch title {
        case StrokeButton.titleList[0]:
            start = 1
            sortName = "sim"
            filteringProcess(button: button)
        case StrokeButton.titleList[1]:
            start = 1
            sortName = "date"
            filteringProcess(button: button)
        case StrokeButton.titleList[2]:
            start = 1
            sortName = "dsc"
            filteringProcess(button: button)
        case StrokeButton.titleList[3]:
            start = 1
            sortName = "asc"
            filteringProcess(button: button)
        default:
            print("title error")
            break
        }
    }
    
    func filteringProcess(button: UIButton) {
        callRequest()
        reloadButtonColor(button: button)
        scrollToUp()
    }
    
    // 새로 생각해본 로직 - 중복되게 안할 수 있는 방법
    func reloadButtonColor(button: UIButton) {
        
        for index in 0...3 {
            if index == button.tag {
                filteringButtons[index].configuration?.baseBackgroundColor = .label
                filteringButtons[index].configuration?.baseForegroundColor = .systemBackground
            } else {
                filteringButtons[index].configuration?.baseBackgroundColor = .systemBackground
                filteringButtons[index].configuration?.baseForegroundColor = .label
            }
        }
    }
    
    func scrollToUp() {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }

}

// MARK: - collectionView 설정
extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentArray = list[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        
        let url = currentArray.image
        
        guard let intPrice = Int(currentArray.price)?.formatted() else { return UICollectionViewCell() }
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: cell.thumnailImageView.frame.width, height: cell.thumnailImageView.frame.height))
        
        cell.thumnailImageView.kf.setImage(with: URL(string: url),
                                           options: [.processor(processor),
                                                     .scaleFactor(UIScreen.main.scale),
                                                     .cacheOriginalImage])
        cell.thumnailImageView.contentMode = .scaleAspectFill
        cell.mallNameLabel.text = currentArray.mallName
        cell.titleLabel.text = currentArray.title.escapingHTML
        cell.priceLabel.text = String(intPrice) + "원"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for item in indexPaths {
            
            if list.count - 5 == item.row && list.count < self.total {
                start += list.count
                callRequest()
            } else if list.count >= self.total {  // 좀 더 죻은 방법 찾아보기
                isEnd = true
            }
        }
    }
}

// MARK: - 레이아웃 및 속성 설정
extension SearchResultViewController: ShoppingConfigure {
    func configHierarchy() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
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
        navigationItem.title = keyword
        
        for index in 0...3 {
            filteringButtons[index].addTarget(self, action: #selector(filteringButtonTapped), for: .touchUpInside)
        }
    }
    
    
}
