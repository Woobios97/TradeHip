//
//  PersistenceManager.swift
//  TradeHip
//
//  Created by 김우섭 on 11/7/23.
//

import Foundation

final class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let userDefaults: UserDefaults = .standard
    
    private struct Constants {
        
    }
    
    private init() {}
    
    // MARK: - Public
    
    public var watchlist: [String] {
        return []
    }
    
    public func addToWatchlist() {
        
    }
    
    public func removeFromWatchlist() {
        
    }
    
    // MARK: - Private
    
    private var hasOnboarded: Bool {
        return false
    }
}
