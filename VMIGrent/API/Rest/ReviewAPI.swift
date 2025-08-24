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
    

