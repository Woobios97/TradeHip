//
//  NewsStory.swift
//  TradeHip
//
//  Created by 김우섭 on 11/10/23.
//

import Foundation

/// 뉴스기사
struct NewsStory: Codable {
    let category: String
    let datetime: TimeInterval
    let headline: String
    let image: String
    let related: String
    let source: String
    let summary: String
    let url: String
}
