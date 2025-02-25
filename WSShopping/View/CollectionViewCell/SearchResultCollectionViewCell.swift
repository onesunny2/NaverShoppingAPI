//
//  SearchResultCollectionViewCell.swift
//  WSShopping
//
//  Created by Lee Wonsun on 1/15/25.
//

import UIKit
import Kingfisher
import SnapKit

final class SearchResultCollectionViewCell: UICollectionViewCell {
    
    static let id = "SearchResultCollectionViewCell"
    
    let thumnailImageView = UIImageView()
    lazy var mallNameLabel = ResultLabel(title: "", size: 11, weight: .light, color: .lightGray)
    lazy var titleLabel = ResultLabel(title: "", size: 12, weight: .regular, color: .label, line: 2)
    lazy var priceLabel = ResultLabel(title: "", size: 15, weight: .semibold, color: .label)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        configImageView()
        configLabel()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        thumnailImageView.layer.cornerRadius = 15
        thumnailImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumnailImageView.image = UIImage()
        mallNameLabel.text = ""
        titleLabel.text = ""
        priceLabel.text = ""
    }

}

extension SearchResultCollectionViewCell {
    
    func configImageView() {
        contentView.addSubview(thumnailImageView)
        
        thumnailImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(self.frame.height * 0.7)
        }
        
    }
    
    func configLabel() {
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        
        mallNameLabel.snp.makeConstraints {
            $0.top.equalTo(thumnailImageView.snp.bottom).offset(3)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mallNameLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
        }
    }
    
    func configureCell(url: String, mallName: String, title: String, price: String) {
        let processor = DownsamplingImageProcessor(size: CGSize(width: thumnailImageView.frame.width, height: thumnailImageView.frame.height))
        
        thumnailImageView.kf.setImage(with: URL(string: url),
                                           options: [
                                            .processor(processor),
                                            .scaleFactor(UIScreen.main.scale),
                                            .cacheOriginalImage
                                           ])
        thumnailImageView.contentMode = .scaleAspectFill
        mallNameLabel.text = mallName
        titleLabel.text = title.escapingHTML
        priceLabel.text = price + "원"
    }
}
