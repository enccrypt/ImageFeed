//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 16.10.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    // MARK: - Public Properties
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "Auth token")
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: "Auth token")
            } else {
                KeychainWrapper.standard.removeObject(forKey: "Auth token")
            }
        }
    }
    // MARK: - Private Properties
    private enum Keys: String {
        case token
    }
}

