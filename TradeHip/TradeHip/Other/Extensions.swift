//
//  Extensions.swift
//  TradeHip
//
//  Created by 김우섭 on 11/7/23.
//

import Foundation
import UIKit

// MARK: - Notification

extension Notification.Name {
    /// 관심 목록에 기호가 추가될 때 알림
    static let didAddToWatchList = Notification.Name("didAddToWatchList")
}

// MARK: - NumberFormatter

extension NumberFormatter {
    /// 퍼센트 Formatter
    static let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    
    /// 십진수 Formatter
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

// MARK: - ImageView
extension UIImageView {
    /// url에서 이미지 가져오기
    /// - Parameter url: 가져올 URL
    func setImage(with url: URL?) {
        guard let url = url else {
            return
        }
        DispatchQueue.global(qos: .userInteractive).async {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}


// MARK: - String
extension String {
    /// 시간 간격으로 문자열 생성
    /// - Parameter timeInterval: Timeinterval since 1970
    /// - Returns: 형식화된 문자열
    static func string(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        return DateFormatter.prettyDateFormatter.string(from: date)
    }
    
    /// 백분율 형식의 문자열
    /// - Parameter double: format 위한 Double
    /// - Returns: 백분율 형식의 문자열
    static func percentage(from double: Double) -> String {
        let formatter = NumberFormatter.percentFormatter
        return formatter.string(from: NSNumber(value: double)) ?? "\(double)"
    }
    
    /// 숫자를 문자열로 포맷
    /// - Parameter number:format를 위한 Number
    /// - Returns: 형식화된 문자열
    static func formatted(number: Double) -> String {
        let formatter = NumberFormatter.numberFormatter
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

// MARK: - DateFormatter
extension DateFormatter {
    static let newsDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    static let prettyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

// MARK: - Add Subview
extension UIView {
    /// 여러 하위 뷰 추가
    /// - Parameter views: Collection of subviews
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}

// MARK: - Framing

extension UIView {
    /// Width of view
    var width: CGFloat {
        frame.size.width
    }
    
    /// Height of view
    var height: CGFloat {
        frame.size.height
    }
    
    /// Left edge of view
    var left: CGFloat {
        frame.origin.x
    }
    
    /// Right edge of view
    var right: CGFloat {
        left + width
    }
    
    /// Top edge of view
    var top: CGFloat {
        frame.origin.y
    }
    
    /// Bottom edge of view
    var bottom: CGFloat {
        top + height
    }
}

// MARK: - CandleStick Sorting
extension Array where Element == CandleStick {
    func getPercentage() -> Double {
        let latestDate = self[0].date
        guard let latestClose = self.first?.close,
            let priorClose = self.first(where: {
                !Calendar.current.isDate($0.date, inSameDayAs: latestDate)
            })?.close else {
            return 0
        }

        let diff = 1 - (priorClose/latestClose)
        return diff
    }
}
