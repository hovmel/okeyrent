//
//  AuthAPI.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 05.06.2022.
//

import Foundation
import Moya

enum AuthAPI: TargetType, BaseAPI {
    case sendPhone(String)
    case checkPhone(String, String)
    
    // MARK: - TargetType & BaseAPI
    
    var baseURL: URL { URLProvider.shared.httpURL }
    
    var path: String {
        switch self {
        case .sendPhone:
            return "/customers/self/auth/sms-send"
        case .checkPhone:
            return "/customers/self/auth/sms-check"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        switch self {
        case .sendPhone(let phone):
            return .requestParameters(parameters: ["phone": phone], encoding: JSONEncoding.default)
        case .checkPhone(let code, let phone):
            return .requestParameters(parameters: ["code": code, "phone": phone], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        if let token = AuthManager.shared.getSessionToken() {
            return [
                "Content-Type": "application/json",
                "Authorization": token,
                "Accept-Language": Locale.current.identifier,
                "Accept": "application/json"
            ]
        } else {
            return [
                "Content-Type": "application/json",
                "Accept-Language": Locale.current.identifier,
                "Accept": "application/json"
            ]
        }
    }
    
    var sampleData: Data { Data() }
}

