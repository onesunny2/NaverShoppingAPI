//
//  MainViewController.swift
//  WSShopping
//
//  Created by Lee Wonsun on 1/15/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    private let searchbar = UISearchBar()
    private let defaultImage = UIImageView()
    private let defaultLabel = UILabel()
    private let rightBarItem = UIBarButtonItem(image: UIImage(systemName: "list.star"))
    private let leftBarItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configHierarchy()
        configLayout()
        defaultContent()
        configView()
        bindData()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        defaultContent()
    }
    
    private func bindData() {
        
        let input = MainViewModel.Input(
            tappedSearchButton: searchbar.rx.searchButtonClicked,
            searchKeyword: searchbar.rx.text,
            tappedBarButtonItem: rightBarItem.rx.tap
        )
        let output = viewModel.transform(input: input)

        output.isValid
            .drive(with: self) { this, value in
                switch value {
                case true:
                    this.defaultImage.image = UIImage(named: this.viewModel.name(.validImage))
                    this.defaultLabel.text = this.viewModel.name(.InvalidText)
                    
                    let vc = SearchResultViewController(keyword: this.searchbar.text ?? "")
                    this.navigationController?.pushViewController(vc, animated: true)
                case false:
                    this.defaultImage.image = UIImage(named: this.viewModel.name(.inValidImage))
                    this.defaultLabel.text = this.viewModel.name(.InvalidText)
                    this.alertWordCount(message: "2글자 이상 입력해주세요!") {
                        UIAlertAction(title: "확인", style: .cancel)
                    }
                }
                
                this.searchbar.text = ""
                this.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        rightBarItem.rx.tap
            .bind(with: self) { this, _ in
                let vc = WishListViewController()
                this.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        leftBarItem.rx.tap
            .bind(with: self) { this, _ in
                let vc = WishRealmListViewController()
                this.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - 레이아웃 및 속성 설정
extension MainViewController: ShoppingConfigure {
    func configHierarchy() {
        
        view.addSubview(searchbar)
        view.addSubview(defaultImage)
        view.addSubview(defaultLabel)
    }
    
    func configLayout() {
        searchbar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
        
        defaultImage.snp.makeConstraints {
            $0.centerY.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(60)
            $0.height.equalTo(defaultImage.snp.width).multipliedBy(1.3)
        }
        
        defaultLabel.snp.makeConstraints {
            $0.centerX.equalTo(defaultImage)
            $0.top.equalTo(defaultImage.snp.bottom).offset(-30)
            $0.width.equalTo(300)
        }
    }
    
    func configView() {
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = HomeContent.title
        navigationItem.rightBarButtonItem = rightBarItem
        navigationItem.leftBarButtonItem = leftBarItem
        
        searchbar.searchBarStyle = .minimal
        searchbar.placeholder = HomeContent.placeholder
        
        defaultImage.contentMode = .scaleAspectFit
        
        defaultLabel.textColor = .label
        defaultLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        defaultLabel.textAlignment = .center
        defaultLabel.numberOfLines = 1
    }
    
    private func defaultContent() {
        defaultImage.image = UIImage(named: viewModel.name(.validImage))
        defaultLabel.text = viewModel.name(.InvalidText)
    }
}
