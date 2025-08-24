//
//  URLProvider.swift
//  GLC
//
//  Created by Михаил on 05.09.2018.
//  Copyright © 2018 Duotek. All rights reserved.
//

import Foundation

struct URLProvider {
    
    static let shared = URLProvider()
    
    private init() {}
    
    #if DEBUG
    private let url: String = "https://api.aadev.ru"
    #else
    private let url: String = "https://api.okeyrent.ru"
    #endif
    

    public var httpURL: URL {
        get {
            return URL(string: url)!
        }
    }

    public func createURLRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("7ae254db1045e17eb61280f46e67c714", forHTTPHeaderField: "socketHash")
        return request
    }
    
}
