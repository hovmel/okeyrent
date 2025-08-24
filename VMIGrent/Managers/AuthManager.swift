//
//  AuthManager.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 06.06.2022.
//

import Foundation

struct AuthManager {
    
    static let shared = AuthManager()
    
    private init() {}
    
    private let KEY_TOKEN = "token"
    
    func setSessionToken(token: String, tokenType: String) {
        UserDefaults.standard.set(tokenType + " " + token, forKey: KEY_TOKEN)
    }
    
    func getSessionToken() -> String? {
        return UserDefaults.standard.string(forKey: KEY_TOKEN)
    }
    
    func removeUser() {
        UserDefaults.standard.removeObject(forKey: KEY_TOKEN)
    }
    
    func authComplete() -> Bool {
        return getSessionToken() != nil
    }
    
    func injectToken(_ components: inout URLComponents) {
        if let token = getSessionToken() {
            components.queryItems = [URLQueryItem(name: "token", value: token)]
        }
    }
    
}
