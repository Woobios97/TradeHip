//
//  HapticsManager.swift
//  TradeHip
//
//  Created by 김우섭 on 11/7/23.
//

import Foundation
import UIKit

final class HapticsManager {
    static let shared = HapticsManager()
    
    private init() {}
    
    // MARK: - Public
    
    public func vibrateForSelection() {
        // 선택 탭 상호작용을 위해 가볍게 진동
    }
    
    // 타입에 따른 진동
}
