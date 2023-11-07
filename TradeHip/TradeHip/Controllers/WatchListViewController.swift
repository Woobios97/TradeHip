//
//  WatchListViewController.swift
//  TradeHip
//
//  Created by 김우섭 on 11/7/23.
//

import UIKit

class WatchListViewController: UIViewController {
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSeachController()
        setUpTitleView()
    }
    
    // MARK: - Private
    
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
        resultVC.delegate = self
        let searchVC = UISearchController(searchResultsController: resultVC)
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
        
        // 사용자가 입력을 멈출 때 검색 횟수를 줄이기 위해 최적화
        
        // 검색을 위한 API call
        
        // 업데이트 resultsController
        resultVC.update(with: ["GOOG"])
        print(#fileID, #function, #line, "this is - \(query)")
    }
        
}

extension WatchListViewController: SearchResultsViewControllerDelegate {
    
    func searchResultsViewController(searchResult: String) {
        // 특정 선택 항목에 대한 주식 세부 정보 표시
    }
    
}
