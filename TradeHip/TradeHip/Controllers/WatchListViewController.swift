//
//  WatchListViewController.swift
//  TradeHip
//
//  Created by 김우섭 on 11/7/23.
//

import UIKit
import FloatingPanel

class WatchListViewController: UIViewController {
    private var searchTimer: Timer?
    
    private var panel: FloatingPanelController?
    
    static var maxChangeWidth: CGFloat = 0
    
    /// Model
    private var watchlistMap: [String: [CandleStick]] = [:]
    
    /// ViewModels
    private var viewModels: [WatchListTableViewCell.ViewModel] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WatchListTableViewCell.self, forCellReuseIdentifier: WatchListTableViewCell.identifier)
        return tableView
    }()
    
    private var observer: NSObjectProtocol?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSeachController()
        setUpTableView()
        fetchWatchlistData()
        setUpFloatingPanel()
        setUpTitleView()
        setUpObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Private
    
    private func setUpObserver() {
        observer = NotificationCenter.default.addObserver(forName: .didAddToWatchList, object: nil, queue: .main) { [weak self] _ in
            self?.viewModels.removeAll()
            self?.fetchWatchlistData()
        }
    }
    
    private func fetchWatchlistData() {
        let symbols = PersistenceManager.shared.watchlist
        
        let group = DispatchGroup()
        
        for symbol in symbols where watchlistMap[symbol] == nil {
            group.enter()
            
            APICaller.shared.marketData(for: symbol) { [weak self] result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let data):
                    let candleSticks = data.candleStick
                    self?.watchlistMap[symbol] = candleSticks
                case .failure(let error):
                    print(#fileID, #function, #line, "this is - \(error)")
                }
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.createViewModels()
            self?.tableView.reloadData()
        }
    }
    
    private func createViewModels() {
        var viewModels = [WatchListTableViewCell.ViewModel]()
        
        for (symbol, candleSticks) in watchlistMap {
            let changePercentage = getChangePercentage(symbol: symbol, data: candleSticks)
            viewModels.append(
                .init(
                    symbol: symbol,
                    companyName: UserDefaults.standard.string(forKey: symbol) ?? "Company",
                    price: getLatestClosingPrice(from: candleSticks),
                    changeColor: changePercentage < 0 ? .systemRed : .systemGreen,
                    changePercnetage: .percentage(from: changePercentage),
                    chartViewModel: .init(
                        data: candleSticks.reversed().map{ $0.close },
                        showLegned: false,
                        showAxis: false
                    )
                )
            )
            
            self.viewModels = viewModels
        }
    }
    
    private func getChangePercentage(symbol: String, data: [CandleStick]) -> Double {
        let latestdate = data[0].date
        guard let latestClose = data.first?.close,
              let priorClose = data.first(where: {
                  !Calendar.current.isDate($0.date, inSameDayAs: latestdate)
              })?.close else {
            return 0
        }
      
        let diff = 1 - (priorClose/latestClose)
        return diff
    }
    
    private func getLatestClosingPrice(from data: [CandleStick]) -> String {
        guard let closingPrice = data.first?.close else {
            return ""
        }
        return String.formatted(number: closingPrice)
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpFloatingPanel() {
        let vc = NewsViewController(type: .company(symbol: "SNAP"))
        let panel = FloatingPanelController(delegate: self)
        panel.surfaceView.backgroundColor = .secondarySystemBackground
        panel.set(contentViewController: vc)
        panel.addPanel(toParent: self)
        panel.delegate = self
        panel.track(scrollView: vc.tableView)
    }
    
    private func setUpTitleView() {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: navigationController?.navigationBar.height ?? 100))
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: titleView.width - 20, height: titleView.height))
        label.text = "주식"
        label.font = UIFont(name: "BMJUAOTF", size: 40)
        label.textColor = .systemOrange
        
        navigationItem.titleView = titleView
        titleView.addSubview(label)
    }
    
    private func setUpSeachController() {
        let resultVC = SearchResultsViewController()
        let searchVC = UISearchController(searchResultsController: resultVC)
        resultVC.delegate = self
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
}

extension WatchListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              let resultVC = searchController.searchResultsController as? SearchResultsViewController,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        // Reset timer
        searchTimer?.invalidate()
        
        // 새 타이머 시작
        // 사용자가 입력을 멈출 때 검색 횟수를 줄이기 위해 최적화
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
            // 검색을 위한 API call
            APICaller.shared.search(query: query) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        resultVC.update(with: response.result)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        resultVC.update(with: [])
                    }
                    print(#fileID, #function, #line, "this is - \(error)")
                }
            }
        })
    }
}

extension WatchListViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidSelect(searchResult: SearchResult) {
        navigationItem.searchController?.searchBar.resignFirstResponder()
        // 특정 선택 항목에 대한 주식 세부 정보 표시
        print(#fileID, #function, #line, "this is - 눌렸다 \(searchResult.displaySymbol)")
        let vc = StockDetailsViewController()
        let navVC = UINavigationController(rootViewController: vc)
        vc.title = searchResult.description
        present(navVC, animated: true)
    }
}

extension WatchListViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        navigationItem.titleView?.isHidden = fpc.state == .full
    }
}

extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WatchListTableViewCell.identifier, for: indexPath) as? WatchListTableViewCell else {
            fatalError()
        }
        cell.delegate = self
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WatchListTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 선택을 위한 세부정보 열기
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // persistence 업데이트 (데이터변경)
            PersistenceManager.shared.removeFromWatchlist(symbol: viewModels[indexPath.row].symbol)
            
            // viewModel 업데이트 (데이터변경)
            viewModels.remove(at: indexPath.row)
                        
            // 행 삭제 (UI업데이트)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}

extension WatchListViewController: WatchListTableViewCellCellDelegate {
    func didUpdateMaxWidth() {
        // 최적화: 최대 너비를 변경하는 현재 행 이전의 행만 새로 고치기
        tableView.reloadData()
    }
}
