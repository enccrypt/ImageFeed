//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 16.10.2024.
//

import Foundation

final class OAuth2TokenStorage {
    // MARK: - Public Properties
    var token: String? {
        get {
            storage.string(forKey: Keys.token.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    // MARK: - Private Properties
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case token
    }
}

