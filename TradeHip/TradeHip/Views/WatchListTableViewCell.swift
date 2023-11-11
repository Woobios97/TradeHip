//
//  WatchListTableViewCell.swift
//  TradeHip
//
//  Created by 김우섭 on 11/10/23.
//

import UIKit

/// 셀이벤트 deleagate
protocol WatchListTableViewCellCellDelegate: AnyObject {
    func didUpdateMaxWidth()
}

/// 관심목록 항목의 테이블 셀
final class WatchListTableViewCell: UITableViewCell {
    
    static let identifier = "WatchListTableViewCell"
    
    weak var delegate: WatchListTableViewCellCellDelegate?
    
    static let preferredHeight: CGFloat = 60
    
    /// 관심 목록 테이블 셀 viewModel
    struct ViewModel {
        let symbol: String
        let companyName: String
        let price: String // formmated
        let changeColor: UIColor // red or green
        let changePercnetage: String // formatted
        let chartViewModel: StockChartView.ViewModel
    }
    
    /// 심볼이름
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    /// 회사이름
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    /// 가격이름
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    /// 가격  변경
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
        return label
    }()
    
    /// 차트
    private let miniChartView : StockChartView = {
        let chart = StockChartView()
        chart.isUserInteractionEnabled = false
        chart.clipsToBounds = true
        return chart
    }()
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        addSubviews(symbolLabel, nameLabel, miniChartView, priceLabel, changeLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        symbolLabel.sizeToFit()
        nameLabel.sizeToFit()
        priceLabel.sizeToFit()
        changeLabel.sizeToFit()
        
        let yStart: CGFloat = (contentView.height - symbolLabel.height - nameLabel.height) / 2
        symbolLabel.frame = CGRect(x: separatorInset.left, y: yStart, width: symbolLabel.width, height: symbolLabel.height)
        nameLabel.frame = CGRect(x: separatorInset.left, y: symbolLabel.bottom, width: nameLabel.width, height: nameLabel.height)
        let currnetWidth = max(max(priceLabel.width, changeLabel.width), WatchListViewController.maxChangeWidth)
        if currnetWidth > WatchListViewController.maxChangeWidth {
            WatchListViewController.maxChangeWidth = currnetWidth
            delegate?.didUpdateMaxWidth()
        }
        priceLabel.frame = CGRect(x: contentView.width - 10 - currnetWidth, y: (contentView.height - priceLabel.height - changeLabel.height) / 2, width: currnetWidth, height: priceLabel.height)
        changeLabel.frame = CGRect(x: contentView.width - 10 - currnetWidth, y: priceLabel.bottom, width: currnetWidth, height: priceLabel.height)
        
        miniChartView.frame = CGRect(x: priceLabel.left - (contentView.width / 3 ) - 5, y: 6, width: contentView.width / 3, height: contentView.height - 12)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        nameLabel.text = nil
        priceLabel.text = nil
        changeLabel.text = nil
        miniChartView.reset()
    }
    
    /// Configure view
    /// - Parameter viewModel: 뷰모델
    public func configure(with viewModel: ViewModel) {
        symbolLabel.text = viewModel.symbol
        nameLabel.text = viewModel.companyName
        priceLabel.text = viewModel.price
        changeLabel.text = viewModel.changePercnetage
        changeLabel.backgroundColor = viewModel.changeColor
        miniChartView.configure(with: viewModel.chartViewModel)
    }
}
