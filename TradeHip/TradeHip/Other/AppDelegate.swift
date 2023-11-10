//
//  AppDelegate.swift
//  TradeHip
//
//  Created by 김우섭 on 11/7/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        debug()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    private func debug() {
        APICaller.shared.news(for: .company(symbol: "MSFT")) { result in
            switch result {
            case .success(let news):
                print(#fileID, #function, #line, "this is - \(news.count)")
            case .failure(let error):
                print(error)
            }
        }
    }

}

