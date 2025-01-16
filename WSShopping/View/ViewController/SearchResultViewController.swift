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
    var resultCount = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = StrokeButton.titleList
        let isTapped = [true, false, false, false]
        
        for index in 0...3 {
            filteringButtons.append(StrokeButton(title: title[index], isTapped: isTapped[index]))
            filteringButtons[index].tag = index
        }

        configHierarchy()
        configLayout()
        configView()
        
        callRequest(filter: "sim")
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
    
    func callRequest(filter: String) {
        
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(nvtitle)&display=100&sort=\(filter)"
        let headers = HTTPHeaders(["X-Naver-Client-Id": APIKey.clientID, "X-Naver-Client-Secret": APIKey.clientSecret])
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: Shopping.self) { response in
            
            print(response.response?.statusCode)
            
            switch response.result {
            case .success(let value):
                self.resultCountLabel.text = String(value.total.formatted()) + "개의 검색결과"
                list = value.items
                
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
        }
        }
    }
    
    @objc
    func filteringButtonTapped(button: UIButton) {
        
        let title = button.titleLabel?.text
        
        switch title {
        case "정확도":
            callRequest(filter: "sim")
            reloadButtonColor(button: button)
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        case "날짜순":
            callRequest(filter: "date")
            reloadButtonColor(button: button)
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        case "가격높은순":
            callRequest(filter: "dsc")
            reloadButtonColor(button: button)
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        case "가격낮은순":
            callRequest(filter: "asc")
            reloadButtonColor(button: button)
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        default:
            print("title error")
            break
        }
    }
    
    func reloadButtonColor(button: UIButton) {
        for index in 0...3 {
            filteringButtons[index].configuration?.baseBackgroundColor = .systemBackground
            filteringButtons[index].configuration?.baseForegroundColor = .label
        }
        button.configuration?.baseBackgroundColor = .label
        button.configuration?.baseForegroundColor = .systemBackground
    }

}

// MARK: - collectionView 설정
extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        
        for index in 0...3 {
            filteringButtons[index].addTarget(self, action: #selector(filteringButtonTapped), for: .touchUpInside)
        }
    }
    
    
}
