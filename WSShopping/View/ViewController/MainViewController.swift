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
    
    private var homecontent = HomeContent(isValid: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        configHierarchy()
        configLayout()
        configView()
        bindData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        searchbar.text = ""
        
        homecontent.isValid = true
        defaultImage.image = UIImage(named: homecontent.isValidCheck(content: Contents.imageName))
        defaultLabel.text = homecontent.isValidCheck(content: Contents.labelText)
    }
    
    private func bindData() {
        
        viewModel.outputCheckValid.lazyBind { isValid in

            let image = self.viewModel.name(isValid ? .validImage : .inValidImage)
            let text = self.viewModel.name(isValid ? .validText : .InvalidText)
            self.defaultImage.image = UIImage(named: image)
            self.defaultLabel.text = text
            
            if !isValid {
                self.searchbar.text = ""
                self.alertWordCount(message: "2글자 이상 입력해주세요!") {
                    UIAlertAction(title: "확인", style: .cancel)
                }
            } else {
                let vc = SearchResultViewController()
                
                self.navigationController?.pushViewController(vc, animated: true)
            }

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
        
//        guard let keyword = searchBar.text else { return }
//        
//        switch keyword.count {
//        case 0..<2:
//            homecontent.isValid = false
//            defaultImage.image = UIImage(named: homecontent.isValidCheck(content: Contents.imageName))
//            defaultLabel.text = homecontent.isValidCheck(content: Contents.labelText)
//            searchbar.text = ""
//            alertWordCount(message: "2글자 이상 입력해주세요!") {
//                UIAlertAction(title: "확인", style: .cancel)
//            }
//        case 2...:
//            // 화면 전환 시키기 & keyword 다음으로 전달
//            let vc = SearchResultViewController()
//            navigationController?.pushViewController(vc, animated: true)
//            vc.keyword = keyword
//        default:
//            break
//        }
//        
//        view.endEditing(true)
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
            $0.top.equalTo(defaultImage.snp.bottom).offset(homecontent.isValid ? -20 : -60)
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
        
        defaultImage.image = UIImage(named: homecontent.isValidCheck(content: Contents.imageName))
        defaultImage.contentMode = .scaleAspectFit
        
        defaultLabel.text = homecontent.isValidCheck(content: Contents.labelText)
        defaultLabel.textColor = .label
        defaultLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        defaultLabel.textAlignment = .center
        defaultLabel.numberOfLines = 1
    }
    
    
}
