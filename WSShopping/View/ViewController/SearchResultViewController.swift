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
        
        var buttons: [Observable<Int>] = []
        
        for index in 0...3 {
            let list = filteringButtons[index].rx.tap
                .withUnretained(self)
                .map { this, _ in
                    this.filteringButtons.forEach {
                        $0.isSelected = false
                    }
                    
                    return this.filteringButtons[index].tag
                }
            
            buttons.append(list)
        }
        
        let input = SearchResultViewModel.Input(
            buttonTag: buttons,
            prefetchIndexPath: collectionView.rx.prefetchItems,
            tappedProduct: collectionView.rx.modelSelected(ShoppingDetail.self)
        )
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
                    
                    cell.configureCell(url: url, mallName: element.mallName, title: element.title, price: price)
                }
                .disposed(by: disposeBag)
        
        output.startPage
            .map { $0 == 1 }
            .debug("scroll")
            .drive(with: self, onNext: { this, value in
                this.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            })
            .disposed(by: disposeBag)
        
        output.errorMessage
            .bind(with: self) { this, message in
                this.alertError(message: message)
            }
            .disposed(by: disposeBag)
        
        output.webView
            .drive(with: self) { this, vc in
                this.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 레이아웃 및 속성 설정
extension SearchResultViewController: ShoppingConfigure {
    func configHierarchy() {

        for index in 0...3 {

            if index == 0 {
                filteringButtons.append(StrokeButton(sort: viewModel.buttonTitle[index], isSelected: true))
            } else {
                filteringButtons.append(StrokeButton(sort: viewModel.buttonTitle[index], isSelected: false))
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
//            $0.width.equalTo(UIScreen.main.bounds.size.width * 0.85)
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
    }
}
