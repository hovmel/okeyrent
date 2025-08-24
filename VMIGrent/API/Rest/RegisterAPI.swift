//
//  RegisterAPI.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.06.2022.
//

import Moya

enum RegisterAPI: BaseAPI {
    case sendPhone(String)
    case registerPhone(String, String, String, String)
    case registerDevice(String,String,String)
}

extension RegisterAPI: TargetType {
    
    var path: String {
        switch self {
        case .sendPhone:
            return "/customers/self/reg/sms-send"
        case .registerPhone:
            return "/customers/self/reg/sms-check"
        case .registerDevice:
            return "/pushes/tokens/create"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendPhone(_), .registerPhone, .registerDevice:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .sendPhone(let phone):
            let params: [String: Any] = ["phone": phone]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .registerPhone(let code, let phone, let firstName, let secondName):
            let params: [String: Any] = ["code": code,
                                         "phone": phone,
                                         "first_name":firstName,
                                         "last_name":secondName]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .registerDevice(let token, let model, let os):
            let params: [String: Any] = ["token": token,
                                         "device_model": model,
                                         "device_os": os]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
}


