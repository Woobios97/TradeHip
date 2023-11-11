//
//  FinancialMetricsResponse.swift
//  TradeHip
//
//  Created by 김우섭 on 11/11/23.
//

import Foundation

/// API의 측정항목 응답
struct FinancialMetricsResponse: Codable {
    let metric: Metrics
}

/// 재무 지표
struct Metrics: Codable {
    let TenDayAverageTradingVolume: Float
    let AnnualWeekHigh: Double
    let AnnualWeekLow: Double
    let AnnualWeekLowDate: String
    let AnnualWeekPriceReturnDaily: Float
    let beta: Float
    
    enum CodingKeys: String, CodingKey {
        case TenDayAverageTradingVolume = "10DayAverageTradingVolume"
        case AnnualWeekHigh = "52WeekHigh"
        case AnnualWeekLow = "52WeekLow"
        case AnnualWeekLowDate = "52WeekLowDate"
        case AnnualWeekPriceReturnDaily = "52WeekPriceReturnDaily"
        case beta = "beta"
    }
}
