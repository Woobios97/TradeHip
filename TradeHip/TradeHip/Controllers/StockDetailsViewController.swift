//
//  StockDetailsViewController.swift
//  TradeHip
//
//  Created by 김우섭 on 11/7/23.
//

import SafariServices
import UIKit

/// 주식 세부정보를 표시하는 VC
final class StockDetailsViewController: UIViewController {
    // MARK: - Properties
    
    /// 주식 symbol
    private let symbol: String
    /// 회사 name
    private let companyName: String
    /// Collection of data
    private var candleStickData: [CandleStick]
    
    /// 주요뷰
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .secondarySystemBackground
        table.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        table.register(NewsStoryTableViewCell.self, forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
        return table
    }()
    
    /// 뉴스기사 collection
    private var stories: [NewsStory] = []
    
    ///회사 지표
    private var metrics: Metrics?
    
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
        title = companyName
        setUpCloseButton()
        // 뷰표시
        setUpTable()
        // 재무 데이터 // 차트|그래프 표시
        fetchFinancialData()
        // 뉴스표시
        fetchNews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Private
    /// 닫기 버튼 설정
    private func setUpCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    }
    
    /// 닫기 버튼 탭 처리
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    /// Sets up table
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: (view.width * 0.7) + 100))
    }
    
    /// 재무 지표 가져오기
    private func fetchFinancialData() {
        let group = DispatchGroup()
        
        // 필요한 경우 캔들스틱을 가져옵니다.
        if candleStickData.isEmpty {
            group.enter()
            APICaller.shared.marketData(for: symbol) { [weak self] result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    self?.candleStickData = response.candleStick
                case .failure(let error):
                    print(#fileID, #function, #line, "this is - \(error)")
                }
            }
        }
        group.enter()
        APICaller.shared.financialMetrics(for: symbol) { [weak self] result in
            defer {
                group.leave()
            }
            
            switch result {
            case .success(let response):
                let metrics = response.metric
                self?.metrics = metrics
            case .failure(let error):
                print(#fileID, #function, #line, "this is - \(error)")
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.renderChart()
        }
    }
    
    /// 특정 유형에 대한 뉴스 가져오기
    private func fetchNews() {
        APICaller.shared.news(for: .company(symbol: symbol)) { [weak self] result in
            switch result {
            case .success(let stories):
                DispatchQueue.main.async{
                    self?.stories = stories
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(#fileID, #function, #line, "this is - \(error)")
            }
        }
    }
    
    /// 차트 및 측정항목 렌더링
    private func renderChart() {
        // Chart VM | FinancailMetricViewModel
        let headerView = StockDetailHeaderView(frame: CGRect(x: 0, y: 0, width: view.width, height: (view.width * 0.7) + 100))
        var viewModels = [MetricCollectionViewCell.ViewModel]()
        if let metrics = metrics {
            viewModels.append(.init(name: "연간주최고", value: "\(metrics.AnnualWeekHigh)"))
            viewModels.append(.init(name: "연간주최저", value: "\(metrics.AnnualWeekLow)"))
            viewModels.append(.init(name: "연간일일수익률", value: "\(metrics.AnnualWeekPriceReturnDaily)"))
            viewModels.append(.init(name: "시장민감도", value: "\(metrics.beta)"))
            viewModels.append(.init(name: "일중평균거래량", value: "\(metrics.TenDayAverageTradingVolume)"))
        }
        // Configure
        let change = candleStickData.getPercentage()
        headerView.configure(charViewModel: .init(data: candleStickData.reversed().map{ $0.close },
                                                  showLegned: true,
                                                  showAxis: true,
                                                  fillColor: change < 0 ? .systemRed : .systemGreen),
                             metricViewModels: viewModels)
        tableView.tableHeaderView = headerView
    }
}

// MARK: - TableView
extension StockDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.identifier, for: indexPath) as? NewsStoryTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(model: stories[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsStoryTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.identifier) as? NewsHeaderView else {
            return nil
        }
        header.delegate = self
        header.configure(
            with: .init(
                title: symbol.uppercased(),
                shouldShowAddButton: !PersistenceManager.shared.watchlistContains(symbol: symbol)
            )
        )
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let url = URL(string: stories[indexPath.row].url) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}

// MARK: - NewsHeaderViewDelegate
extension StockDetailsViewController: NewsHeaderViewDelegate {
    func newsHeaderViewDidTapAddButton(_ headerView: NewsHeaderView) {
        // Add to watchlist
        headerView.button.isHidden = true
        PersistenceManager.shared.addToWatchlist(symbol: symbol, companyName: companyName)
        let alert = UIAlertController(title: "관심목록을 추가", message: "\(companyName)을 관심목록에 추가했습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
