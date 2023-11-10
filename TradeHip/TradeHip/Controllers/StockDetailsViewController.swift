//
//  StockDetailsViewController.swift
//  TradeHip
//
//  Created by 김우섭 on 11/7/23.
//

import UIKit

class StockDetailsViewController: UIViewController {
    // MARK: - Properties
    
    private let symbol: String
    private let companyName: String
    private var candleStickData: [CandleStick]
    
    // MARK: - init
    // Symbol, 회사 이름, 우리가 보유할 수 있는 모든 차트 데이터
    init(symbol: String, companyName: String, candleStickData: [CandleStick] = []) {
        self.symbol = symbol
        self.companyName = companyName
        self.candleStickData = candleStickData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

}
