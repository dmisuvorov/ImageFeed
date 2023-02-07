//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 03.02.2023.
//

import Foundation

final class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    
    var token: String {
        get {
            guard let data = userDefaults.string(forKey: Keys.token.rawValue) else {
                return .init()
            }
            return data
        }
        set {
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
    private enum Keys: String {
        case token
    }
}
