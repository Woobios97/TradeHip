//
//  SearchResponse.swift
//  TradeHip
//
//  Created by 김우섭 on 11/8/23.
//

import Foundation

/// 검색에 대한 API 응답
struct SearchResponse: Codable {
    let count: Int
    let result: [SearchResult]
}

/// 단일 검색결과
struct SearchResult: Codable {
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
}
