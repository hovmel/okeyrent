//
//  AuthAPI.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 05.06.2022.
//

import Moya

enum AuthAPI: BaseAPI {
    case sendPhone(String)
    case checkPhone(String, String)
}

extension AuthAPI {
    
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


extension AuthAPI: TargetType {
    var path: String {
        switch self {
            case .sendPhone:
                return "/customers/self/auth/sms-send"
            case .checkPhone:
                return "/customers/self/auth/sms-check"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .sendPhone, .checkPhone:
            return .post
        }
    }
    
    var task: Task {
        switch self {
            case .sendPhone(let phone):
                let params: [String: Any] = ["phone": phone]
                return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            case .checkPhone(let code, let phone):
                let params: [String: Any] = ["code": code, "phone": phone]
                return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
}
