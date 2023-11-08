//
//  SearchResponse.swift
//  TradeHip
//
//  Created by 김우섭 on 11/8/23.
//

import Foundation

struct SearchResponse: Codable {
    let count: Int
    let result: [SearchResult]
}

struct SearchResult: Codable {
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
}
