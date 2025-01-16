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
    
    var alamo = AlamofireManager()
    
    let buttonTitle = StrokeButton.titleList
    var currentButton = StrokeButton.titleList[0]
    var nvtitle = ""
    var resultCount = ""
    var start = 1
    var list: [ShoppingDetail] = []
    var filter = "sim"

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
        
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(nvtitle)&display=30&sort=\(filter)&start=\(start)"
        let headers = HTTPHeaders(["X-Naver-Client-Id": APIKey.clientID, "X-Naver-Client-Secret": APIKey.clientSecret])
        
        AF.request(url, method: .get, headers: headers).responseString { value in
            print(value)
        }
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: Shopping.self) { response in
            
            print(response.response?.statusCode)
            
            switch response.result {
            case .success(let value):
                
                self.resultCountLabel.text = String(value.total.formatted()) + "개의 검색결과"
                
                if self.start == 1{
                    self.list = value.items
                    print(self.list.count)
                } else {
                    self.list.append(contentsOf: value.items)
                    print(self.list.count)
                }
                
                self.collectionView.reloadData()
                
            case .failure(let error):
                print(error)
        }
        }
    }
    
    @objc
    func filteringButtonTapped(button: UIButton) {
        
        guard let title = button.titleLabel?.text else { return }
        
        switch title {
        case StrokeButton.titleList[0]:
            filteringProcess(title: title, button: button)
        case StrokeButton.titleList[1]:
            filteringProcess(title: title, button: button)
        case StrokeButton.titleList[2]:
            filteringProcess(title: title, button: button)
        case StrokeButton.titleList[3]:
            filteringProcess(title: title, button: button)
        default:
            print("title error")
            break
        }
    }
    
    func filteringProcess(title: String, button: UIButton) {
        filter = title
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
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
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
            if list.count - 5 == item.row {
                start += list.count
                callRequest()
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
        navigationItem.title = nvtitle
        
        for index in 0...3 {
            filteringButtons[index].addTarget(self, action: #selector(filteringButtonTapped), for: .touchUpInside)
        }
    }
    
    
}
