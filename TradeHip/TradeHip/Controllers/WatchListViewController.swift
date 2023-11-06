//
//  WatchListViewController.swift
//  TradeHip
//
//  Created by 김우섭 on 11/7/23.
//

import UIKit

class WatchListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSeachController()
    }
    
    private func setUpSeachController() {
        let resultVC = SearchResultsViewController()
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
        
        print(#fileID, #function, #line, "this is - \(query)")
    }
        
}
