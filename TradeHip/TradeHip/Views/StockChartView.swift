//
//  StockChartView.swift
//  TradeHip
//
//  Created by 김우섭 on 11/10/23.
//

import UIKit
import Charts

/// 차트를 표시하려면 보기
final class StockChartView: UIView {
    /// 차트 보기 ViewModel
    struct ViewModel {
        let data: [Double]
        let showLegned: Bool
        let showAxis: Bool
        let fillColor: UIColor
    }
    
    /// 차트뷰
    private let chartView: LineChartView = {
        let chartView = LineChartView()
        chartView.pinchZoomEnabled = false
        chartView.setScaleEnabled(true)
        chartView.xAxis.enabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.legend.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        return chartView
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(chartView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = bounds
    }
    
    /// 차트뷰 Reset하기
    func reset() {
        chartView.data = nil
    }
    
    /// Configure VIew
    /// - Parameter viewModel: 뷰모델
    func configure(with viewModel: ViewModel) {
        var entries = [ChartDataEntry]()
        
        for (index, value) in viewModel.data.enumerated() {
            entries.append(
                .init(
                    x: Double(index),
                    y: value
                )
            )
        }
        
        chartView.rightAxis.enabled = viewModel.showAxis
        chartView.legend.enabled = viewModel.showLegned
        
        let dataSet = LineChartDataSet(entries: entries, label: "7 Days")
        dataSet.colors = [UIColor.clear]
        dataSet.fillColor = viewModel.fillColor
        dataSet.highlightColor = .systemGray3
        dataSet.drawFilledEnabled = true
        dataSet.drawIconsEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
    }
}
