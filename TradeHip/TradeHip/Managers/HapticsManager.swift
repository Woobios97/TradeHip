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
    
    /// 선택 탭 상호작용을 위해 가볍게 진동을 실행
    public func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    /// 주어진 유형의 상호작용에 대해 햅틱을 재생
    /// - Parameter type: 실행할 햅틱 피드백 유형
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
