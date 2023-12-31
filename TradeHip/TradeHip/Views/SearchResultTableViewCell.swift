//
//  SearchResultTableViewCell.swift
//  TradeHip
//
//  Created by 김우섭 on 11/8/23.
//

import UIKit

/// 검색 결과에 대한 Tableview 셀
final class SearchResultTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultTableViewCell"
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
