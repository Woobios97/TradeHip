//
//  StockChartView.swift
//  TradeHip
//
//  Created by 김우섭 on 11/10/23.
//

import UIKit

class StockChartView: UIView {
    
    struct ViewModel {
        let data: [Double]
        let showLegned: Bool
        let showAxis: Bool
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    /// ChartView Reset하기
    func reset() {
        
    }
    
    func configure(with viewModel: ViewModel) {
        
    }
}

