//
//  ReviewAPI.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 20.07.2022.
//

import Foundation
import Moya

enum ReviewAPI: BaseAPI {
    case getList(Int)
    case createReview(Int, String?, [[String:Any]])
}

extension ReviewAPI {
    
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


extension ReviewAPI: TargetType {
    
    var path: String {
        switch self {
        case .getList:
            return "/reviews/list"
        case .createReview:
            return "/reviews/create"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getList:
            return .get
        case .createReview:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getList(let id):
            let params: [String: Any] = ["object_id": id]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .createReview(let object_id, let review, let rates):
            var params: [String: Any] = ["object_id":object_id,
                                         "rates":rates]
            if let review = review {
                params["review"] = review
            }
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
}
    

