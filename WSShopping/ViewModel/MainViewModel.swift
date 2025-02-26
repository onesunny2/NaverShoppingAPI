//
//  MainViewModel.swift
//  WSShopping
//
//  Created by Lee Wonsun on 2/6/25.
//

import Foundation
import RxSwift
import RxCocoa

enum HomeContents: String {
    case validImage = "shopping"
    case inValidImage = "nono"
    case validText = "이것도 사고 저것도 살래 :>"
    case InvalidText = "2글자 이상으로 검색해주세요!"
}

final class MainViewModel: BaseViewModel {
    
    struct Input {
        let tappedSearchButton: ControlEvent<Void>
        let searchKeyword: ControlProperty<String?>
        let tappedBarButtonItem: ControlEvent<Void>
    }
    
    struct Output {
        let isValid: Driver<Bool>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let isValid = PublishRelay<Bool>()
        
        input.tappedSearchButton
            .debug("Before UntilChanged")
            .withLatestFrom(input.searchKeyword)
            .distinctUntilChanged()
            .compactMap { $0 }
            .debug("After UntilChanged")
            .bind(with: self) { this, keyword in
                switch keyword.count {
                case ..<2:
                    isValid.accept(false)
                case 2...:
                    isValid.accept(true)
                default:
                    print("keyword error")
                    break
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            isValid: isValid.asDriver(onErrorJustReturn: false)
        )
    }
}

extension MainViewModel {
    
    func name(_ type: HomeContents) -> String {
        return type.rawValue
    }
}
