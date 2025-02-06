//
//  MainViewController.swift
//  WSShopping
//
//  Created by Lee Wonsun on 1/15/25.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    
    private let searchbar = UISearchBar()
    private let defaultImage = UIImageView()
    private let defaultLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        configHierarchy()
        configLayout()
        defaultContent()
        configView()
        bindData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        defaultContent()
    }
    
    private func bindData() {
        
        viewModel.outputCheckValid.lazyBind { isValid in
            
            if !isValid {
                self.defaultImage.image = UIImage(named: self.viewModel.name(.inValidImage))
                self.defaultLabel.text = self.viewModel.name(.InvalidText)
                self.alertWordCount(message: "2글자 이상 입력해주세요!") {
                    UIAlertAction(title: "확인", style: .cancel)
                }
            } else {
                self.defaultImage.image = UIImage(named: self.viewModel.name(.validImage))
                self.defaultLabel.text = self.viewModel.name(.InvalidText)
                
                let vc = SearchResultViewController()
                vc.keyword = self.viewModel.inputSearchText.value ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            self.searchbar.text = ""
            self.view.endEditing(true)
        }
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    

}

// MARK: - 서치바 관련 액션
extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        viewModel.inputSearchText.value = searchBar.text
    }
}


// MARK: - 레이아웃 및 속성 설정
extension MainViewController: ShoppingConfigure {
    func configHierarchy() {
        searchbar.delegate = self
    
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
