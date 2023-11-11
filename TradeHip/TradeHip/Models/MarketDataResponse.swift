//
//  MarketDataResponse.swift
//  TradeHip
//
//  Created by 김우섭 on 11/10/23.
//

import Foundation

/// 시장 데이터 반응
struct MarketDataResponse: Codable {
    let open: [Double]
    let close: [Double]
    let high: [Double]
    let low: [Double]
    let status: String
    let timestamps: [TimeInterval]
    
    enum CodingKeys: String, CodingKey {
        case open = "o"
        case close = "c"
        case high = "h"
        case low = "l"
        case status = "s"
        case timestamps = "t"
    }
    
    /// 시장 데이터를 캔들스틱 모델 배열로 변환
    var candleStick: [CandleStick] {
        var result = [CandleStick]()
        for index in 0..<open.count {
            result.append(
                .init(
                    date: Date(timeIntervalSince1970: timestamps[index]),
                    high: high[index],
                    low: low[index],
                    open: open[index],
                    close: close[index]
                )
            )
        }
        let sortedData = result.sorted(by: { $0.date > $1.date })
        return sortedData
    }
}

/// 하루 동안의 데이터를 나타내는 모델
struct CandleStick {
    let date: Date
    let high: Double
    let low: Double
    let open: Double
    let close: Double
}
