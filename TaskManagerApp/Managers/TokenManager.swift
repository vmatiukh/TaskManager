//
//  TokenManager.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/4/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//

import Foundation
import KeychainSwift

class TokenManager {
    private static let tokenKey = "token_key"
    static func save(token: String?) {
        let keychain = KeychainSwift()
        if let token = token {
            keychain.set(token, forKey: tokenKey)
        } else {
            keychain.delete(tokenKey)
        }
    }
    
    static var loadToken:String? {
        return KeychainSwift().get(tokenKey)
    }
}
