//
//  APICaller.swift
//  TradeHip
//
//  Created by 김우섭 on 11/7/23.
//

import Foundation

/// API 호출을 관리하는 객체
final class APICaller {
    /// Singleton
    public static let shared = APICaller()
    
    /// Constants
    private struct Constants {
        static let apiKey = "cl57b6hr01qsak9814bgcl57b6hr01qsak9814c0"
        static let sandboxApikey = ""
        static let baseUrl = "https://finnhub.io/api/v1/"
        static let day: TimeInterval = 3600 * 24
    }
    
    /// Private constructor
    private init() {}
    
    // MARK: - Public
    
    /// 회사검색
    /// - Parameters:
    ///   - query: 쿼리 문자열(기호 또는 이름)
    ///   - completion: 결과에 대한 콜백
    public func search(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        guard let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        request(
            url: url(
                for: .search,
                queryParams: ["q":safeQuery]
            ),
            expecting: SearchResponse.self,
            completion: completion
        )
    }
    
    ///  유형별 뉴스 받기
    /// - Parameters:
    ///   - type: 회사 또는 주요 뉴스
    ///   - completion: 결과 콜백
    public func news(for type: NewsViewController.`Type`, completion: @escaping (Result<[NewsStory], Error>) -> Void) {
        switch type {
        case .topStories:
            request(url: url(for: .topStories, queryParams: ["category:": "general"]), expecting: [NewsStory].self, completion: completion)
        case .company(let symbol):
            let today = Date()
            let oneMonthBack = today.addingTimeInterval(-(Constants.day * 7))
            request(url: url(for: .companyNews,
                             queryParams: [
                                "symbol": symbol,
                                "from": DateFormatter.newsDateFormatter.string(from: oneMonthBack),
                                "to": DateFormatter.newsDateFormatter.string(from: today)
                             ]
                            ),
                    expecting: [NewsStory].self,
                    completion: completion)
        }
    }
    
    /// 시장 데이터 가져오기
    /// - Parameters:
    ///   - symbol: 주어진 sumbol
    ///   - numberOfDays: 오늘부터 남은 일수
    ///   - completion: 결과 콜백
    public func marketData(for symbol: String, numberOfDays: TimeInterval = 7, completion: @escaping (Result<MarketDataResponse, Error>) -> Void) {
        let today = Date().addingTimeInterval(-(Constants.day))
        let prior = today.addingTimeInterval(-(Constants.day * numberOfDays))
        request(
            url: url(for: .marketData,
                     queryParams: [
                        "symbol": symbol,
                        "resolution": "1",
                        "from": "\(Int(prior.timeIntervalSince1970))",
                        "to": "\(Int(today.timeIntervalSince1970))"
                     ]
                    ),
            expecting: MarketDataResponse.self,
            completion: completion)
    }
    
    public func financialMetrics(for symbol: String, completion: @escaping (Result<FinancialMetricsResponse, Error>) -> Void) {
        request(
            url: url(for: .financials,
                     queryParams: [
                        "symbol": symbol,
                        "metric": "all"
                     ]
                    ),
            expecting: FinancialMetricsResponse.self,
            completion: completion)
    }
    
    // MARK: - Private
    
    private enum Endpoint: String {
        case search
        case topStories = "news"
        case companyNews = "company-news"
        case marketData = "stock/candle"
        case financials = "stock/metric"
    }
    
    private enum APIError: Error {
        case noDataReturned
        case invalidUrl
    }
    
    /// 엔드포인트에 대한 URL을 생성해 보세요.
    /// - Parameters:
    ///   - endpoint: 생성할 엔드포인트
    ///   - queryParams: 추가 쿼리 인수
    /// - Returns: Optional URL
    private func url(for endpoint: Endpoint,
                     queryParams: [String: String] = [:]
    ) -> URL? {
        var urlString = Constants.baseUrl + endpoint.rawValue
        
        var queryItems = [URLQueryItem]()
        
        // Add any parameters
        for (key, value) in queryParams {
            queryItems.append(.init(name: key, value: value))
        }
        
        // Add token
        queryItems.append(.init(name: "token", value: Constants.apiKey))
        
        // 쿼리 항목을 접미사 문자열로 변환합니다.
        urlString += "?" + queryItems.map{ "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        
        print(#fileID, #function, #line, "this is - \(urlString)")
        
        return URL(string: urlString)
    }
    
    /// API 호출 수행
    /// - Parameters:
    ///   - url: URL
    ///   - expecting: 데이터를 디코딩할 것으로 예상되는 유형
    ///   - completion: 결과 콜백
    private func request<T: Codable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            // 유효하지않은 에러
            completion(.failure(APIError.invalidUrl))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.noDataReturned))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}
