//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Суворов Дмитрий Владимирович on 03.02.2023.
//

import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private let keychainWrapper = KeychainWrapper.standard
    
    var token: String {
        get {
            guard let data = keychainWrapper.string(forKey: Keys.token.rawValue) else {
                return .init()
            }
            return data
        }
        set {
            keychainWrapper.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
    private enum Keys: String {
        case token
    }
}
