//
//  TradeHipTests.swift
//  TradeHipTests
//
//  Created by 김우섭 on 11/11/23.
//

/// TradeHip 앱을 테스트 가능하도록 가져온다,
@testable import TradeHip

import XCTest

class TradeHipTests: XCTestCase {

    func testSometing() {
        let number = 1
        let string = "1"
        XCTAssertEqual(number, Int(string), "Numbers do not match")
    }

    func testCandleStickDataConversion() {
        let doubles: [Double] = Array(repeating: 12.2, count: 10)
        var timestamps: [TimeInterval] = []
        for x in 0..<12 {
            let interval = Date().addingTimeInterval(3600 * TimeInterval(x)).timeIntervalSince1970
            timestamps.append(interval)
        }
        timestamps.shuffle()
        
        /// 시장 데이터를 초기화
        let marketData = MarketDataResponse(
            open: doubles,
            close: doubles,
            high: doubles,
            low: doubles,
            status: "success",
            timestamps: timestamps
        )
        
        /// 캔들스틱 데이터를 생성
        let candleSticks = marketData.candleStick
        
        /// 각 데이터 배열의 길이가 일치하는지 검증
        XCTAssertEqual(candleSticks.count, marketData.open.count)
        XCTAssertEqual(candleSticks.count, marketData.close.count)
        XCTAssertEqual(candleSticks.count, marketData.high.count)
        XCTAssertEqual(candleSticks.count, marketData.low.count)
        XCTAssertEqual(candleSticks.count, marketData.timestamps.count)

        /// 정렬을 검증한다
        let dates = candleSticks.map { $0.date }
        for x in 0 ..< dates.count-1 {
            let current = dates[x]
            let next = dates[x+1]
            XCTAssertTrue(current > next, "\(current) date should be greater than \(next) date")
        }
    }
}

