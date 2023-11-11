//
//  MetricCollectionViewCell.swift
//  TradeHip
//
//  Created by 김우섭 on 11/11/23.
//

import UIKit

/// Metric 테이블뷰셀
final class MetricCollectionViewCell: UICollectionViewCell {
    static let identifier = "MetricCollectionViewCell"
    
    /// Metric 테이블셀 viewModel
    struct ViewModel {
        let name: String
        let value: String
    }
    
    /// 지표이름
    private let nameLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    /// value
    private let valueLabel: UILabel = {
       let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubviews(nameLabel, valueLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        valueLabel.sizeToFit()
        nameLabel.sizeToFit()
        
        nameLabel.frame = CGRect(x: 3, y: 0, width: nameLabel.width, height: contentView.height)
        valueLabel.frame = CGRect(x: nameLabel.right + 3, y: 0, width: valueLabel.width, height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        valueLabel.text = nil
    }
    
    /// Configure view
    /// - Parameter viewModel: 뷰모델
    func configure(with viewModel: ViewModel) {
        nameLabel.text = viewModel.name + ": "
        valueLabel.text = viewModel.value
    }
}
