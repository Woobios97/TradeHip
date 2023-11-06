//
//  APICaller.swift
//  Stocks
//
//  Created by 김우섭 on 11/7/23.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private struct Constants {
        static let apiKey = ""
        static let sandboxApikey = ""
        static let baseUrl = ""
    }
    
    private init() {}
    
    // MARK: - Public
    
    // 주식 정보 얻기
    
    // 주식 검색
    
    // MARK: - Private
    
    private enum Endpoint: String {
        case search
    }
    
    private enum APIError: Error {
        case noDataReturned
        case invalidUrl
    }
    
    private func url(for endpoint: Endpoint,
                     queryParams: [String: String] = [:]
    ) -> URL? {
        
        return nil
    }
    
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
