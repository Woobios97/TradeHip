//
//  SearchResultTableViewCell.swift
//  TradeHip
//
//  Created by 김우섭 on 11/8/23.
//

import UIKit

/// Tableview cell for search result
final class SearchResultTableViewCell: UITableViewCell {
    /// Identifier for cell
    static let identifier = "SearchResultTableViewCell"
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
