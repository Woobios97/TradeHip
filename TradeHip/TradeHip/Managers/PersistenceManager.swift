//
//  PersistenceManager.swift
//  TradeHip
//
//  Created by 김우섭 on 11/7/23.
//

import Foundation

/// 저장된 캐시를 관리하는 객체
final class PersistenceManager {
    /// SIngleston
    static let shared = PersistenceManager()
    
    /// UserDefaults
    private let userDefaults: UserDefaults = .standard
    
    /// Constants
    private struct Constants {
        static let onboardedKey = "hasOnboarded"
        static let watchListKey = "watchlist"
    }
    
    private init() {}
    
    // MARK: - Public
    
    /// 유저 관심목록 가져오기
    public var watchlist: [String] {
        if !hasOnboarded {
            userDefaults.set(true, forKey: Constants.onboardedKey)
            setUpDefaults()
        }
        return userDefaults.stringArray(forKey: Constants.watchListKey) ?? []
    }
    
    /// 관심 목록에 항목이 포함되어 있는지 확인
    /// - Parameter symbol: 확인해야 할 Symbol
    /// - Returns: Boolean
    public func watchlistContains(symbol: String) -> Bool {
        return watchlist.contains(symbol)
    }
    
    /// 관심 목록에 symbol 추가
    /// - Parameters:
    ///   - symbol: 추가할 Symbol
    ///   - companyName: 추가되는 Symbol의 회사명
    public func addToWatchlist(symbol: String, companyName: String) {
        var current = watchlist
        current.append(symbol)
        userDefaults.set(current, forKey: Constants.watchListKey)
        userDefaults.set(companyName, forKey: symbol)
        NotificationCenter.default.post(name: .didAddToWatchList, object: nil)
    }
    
    /// 관심 목록에서 항목 제거
    /// - Parameter symbol: 삭제되는 Symbol
    public func removeFromWatchlist(symbol: String) {
        var newList = [String]()
        
        userDefaults.set(nil, forKey: symbol)
        for item in watchlist where item != symbol {
            newList.append(item)
        }
        
        userDefaults.set(newList, forKey: Constants.watchListKey)
    }
    
    // MARK: - Private
    
    /// 사용자가 온보딩되었는지 확인
    private var hasOnboarded: Bool {
        return userDefaults.bool(forKey: Constants.onboardedKey)
    }
    
    private func setUpDefaults() {
        let map: [String: String] = [
            "AAPL": "Apple Inc",
            "MSFT": "Microsoft Corporation",
            "SNAP": "Snap Inc.",
            "GOOG": "Alphabet",
            "AMZN": "Amazon.com. Inc",
            "META": "Meta Platforms, Inc.",
            "NVDA": "Nvidia Inc.",
            "NKE": "Nike",
            "PINS": "Pinterest Inc.",
            "TSLA": "Tesla, Inc.",
        ]
        
        let symbols = map.keys.map { $0 }
        userDefaults.set(symbols, forKey: Constants.watchListKey)
        
        for (symbol, name) in map {
            userDefaults.set(name, forKey: symbol)
        }
    }
}
