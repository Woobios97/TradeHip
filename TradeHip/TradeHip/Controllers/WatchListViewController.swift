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
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSeachController()
        setUpFloatingPanel()
        setUpTitleView()
    }
    
    // MARK: - Private
    
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
