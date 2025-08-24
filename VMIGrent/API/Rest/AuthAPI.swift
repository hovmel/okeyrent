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
