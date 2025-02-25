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
import RxCocoa
import RxSwift

final class SearchResultViewController: UIViewController {
    
    private let viewModel: SearchResultViewModel
    private let disposeBag = DisposeBag()
    
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

    
    let buttonTitle = Sort.allCases
    
    init(keyword: String) {
        viewModel = SearchResultViewModel(keyword: keyword)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configHierarchy()
        configLayout()
        configView()
        bindData()
    }
    
    private func bindData() {
        
        let input = SearchResultViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.totalCount
            .drive(with: self) { this, value in
                this.resultCountLabel.text = String(value.formatted()) + "개의 검색결과"
            }
            .disposed(by: disposeBag)
        
        output.shoppingDetail
            .drive(
                collectionView.rx.items(
                    cellIdentifier: SearchResultCollectionViewCell.id,
                    cellType: SearchResultCollectionViewCell.self
                )) { (item, element, cell) in
                    
                    let url = element.image
                    let price = Int(element.price)?.formatted() ?? ""
                    let processor = DownsamplingImageProcessor(size: CGSize(width: cell.thumnailImageView.frame.width, height: cell.thumnailImageView.frame.height))
                    
                    cell.thumnailImageView.kf.setImage(with: URL(string: url),
                                                       options: [
                                                        .processor(processor),
                                                        .scaleFactor(UIScreen.main.scale),
                                                        .cacheOriginalImage
                                                       ])
                    cell.thumnailImageView.contentMode = .scaleAspectFill
                    cell.mallNameLabel.text = element.mallName
                    cell.titleLabel.text = element.title.escapingHTML
                    cell.priceLabel.text = String(price) + "원"
                }
                .disposed(by: disposeBag)

        
        //=================이전코드========================
        
        viewModel.outputRequest.bind { data in
            // start = 1 일 때 데이터 리로드 하도록
            self.viewModel.outputReloadAction.value = {
                self.collectionView.reloadData()
            }()
        }
        
        viewModel.outputStart.lazyBind { _ in
            self.collectionView.reloadData()
        }
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        
        let sectionInsect: CGFloat = 10
        let cellSpacing: CGFloat = 15
        let cellWidth: CGFloat = (UIScreen.main.bounds.width - (sectionInsect * 2 + cellSpacing)) / 2
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.5)
        layout.sectionInset = UIEdgeInsets(top: 2, left: sectionInsect, bottom: 2, right: sectionInsect)
        
        return layout
    }
    
    @objc
    func filteringButtonTapped(button: UIButton) {
 
//        guard let title = button.titleLabel?.text else { return }
        
//        switch title {
//        case StrokeButton.titleList[0]:
//            viewModel.inputQuery.value.2 = 1
//            viewModel.inputQuery.value.1 = "sim"
//            filteringProcess(button: button)
//        case StrokeButton.titleList[1]:
//            viewModel.inputQuery.value.2 = 1
//            viewModel.inputQuery.value.1  = "date"
//            filteringProcess(button: button)
//        case StrokeButton.titleList[2]:
//            viewModel.inputQuery.value.2 = 1
//            viewModel.inputQuery.value.1  = "dsc"
//            filteringProcess(button: button)
//        case StrokeButton.titleList[3]:
//            viewModel.inputQuery.value.2 = 1
//            viewModel.inputQuery.value.1  = "asc"
//            filteringProcess(button: button)
//        default:
//            print("title error")
//            break
//        }
        
        filteringButtons.forEach {
            $0.isSelected = false
        }
        
//        let tag = button.tag
//  
//        switch tag {
//        case 0:
//            
//        case 1:
//            
//        case 2:
//            
//        case 3:
//            
//        default:
//            print("button title error")
//            break
//        }
        
    }
    
    func filteringProcess(button: UIButton) {
        viewModel.inputRequest.value = ()
        scrollToUp()
    }
    
    func scrollToUp() {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - collectionView 설정
extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        viewModel.inputPrefetch.value = (indexPaths)
        
//        for item in indexPaths {
//            
//            if list.count - 5 == item.row && list.count < self.total {
//                start += list.count
//                callRequest()
//            } else if list.count >= self.total {  // 좀 더 죻은 방법 찾아보기
//                isEnd = true
//            }
//        }
    }
}

// MARK: - 레이아웃 및 속성 설정
extension SearchResultViewController: ShoppingConfigure {
    func configHierarchy() {

        for index in 0...3 {

            if index == 0 {
                filteringButtons.append(StrokeButton(sort: buttonTitle[index], isSelected: true))
            } else {
                filteringButtons.append(StrokeButton(sort: buttonTitle[index], isSelected: false))
            }
            
            filteringButtons[index].tag = index
        }
        
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
        navigationItem.title = viewModel.keyword
        
        for index in 0...3 {
            filteringButtons[index].addTarget(self, action: #selector(filteringButtonTapped), for: .touchUpInside)
        }
    }
    
    
}
