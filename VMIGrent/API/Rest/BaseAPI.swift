//
//  BaseAPI.swift
//  GLC
//
//  Created by Михаил on 05.09.2018.
//  Copyright © 2018 Duotek. All rights reserved.
//

import Foundation

protocol BaseAPI {
    var baseURL: URL { get }
    var headers: [String: String]? { get }
    var sampleData: Data { get }
}

extension BaseAPI {
    
    var baseURL: URL { return URLProvider.shared.httpURL }
    
    var locale: String {
        var locale = Locale.current.identifier
        if !locale.contains("_") {
            if locale != "en" {
                locale = locale + "_" + locale.uppercased()
            } else {
                locale = locale + "_US"
            }
        }
        return locale
    }
    
    var headers: [String: String]? {
        if let token = AuthManager.shared.getSessionToken() {
            return ["Content-Type": "application/json",
                    "Authorization" : "\(token)",
                    "Accept-Language": self.locale,
                    "Accept": "application/json"]
        } else {
            return ["Content-Type": "application/json",
                    "Accept-Language": self.locale,
                    "Accept": "application/json"]
        }
    }
    
    var sampleData: Data { return Data() }
}
