//
//  ObjectsAPI.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 17.06.2022.
//

import Moya

enum ObjectsAPI: BaseAPI {
    case getCities(String?, Int?, Int?)
    case getDetail(Int)
    case getList([Int]?, Int?, Int?)
    case getFavorites(String?, Int?, Int?)
    case addFavorite(Int)
    case removeFavorite(Int)
    case getListMap(Double, Double, Double, Double, Double, Double, Double, Double, String?, String?, Int?, Int?, [String], [Int], Int?, [Int])
    case getDetailShort(Int)
    case getDashboard
}

extension ObjectsAPI {
    
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


//extension AuthAPI: TargetType {
//    var path: String {
//        switch self {
//            case .sendPhone:
//                return "/customers/self/auth/sms-send"
//            case .checkPhone:
//                return "/customers/self/auth/sms-check"
//        }
//    }
//    
//    var method: Moya.Method {
//        switch self {
//            case .sendPhone, .checkPhone:
//            return .post
//        }
//    }
//    
//    var task: Task {
//        switch self {
//            case .sendPhone(let phone):
//                let params: [String: Any] = ["phone": phone]
//                return .requestParameters(parameters: params, encoding: JSONEncoding.default)
//            case .checkPhone(let code, let phone):
//                let params: [String: Any] = ["code": code, "phone": phone]
//                return .requestParameters(parameters: params, encoding: JSONEncoding.default)
//        }
//    }
//}



extension ObjectsAPI: TargetType {
    
    var path: String {
        switch self {
        case .getCities:
            return "/geo/cities"
        case .getDetail:
            return "/objects/detail"
        case .getList:
            return "/objects/list"
        case .getFavorites:
            return "/objects/favorites/list"
        case .addFavorite:
            return "/objects/favorites/add"
        case .removeFavorite:
            return "/objects/favorites/remove"
        case .getListMap:
            return "/objects/list-map"
        case .getDetailShort:
            return "/objects/detail-short"
        case .getDashboard:
            return "/common/dashboard"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCities, .getDetail, .getList, .getFavorites, .getListMap, .getDetailShort, .getDashboard:
            return .get
        case .addFavorite, .removeFavorite:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getDashboard:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .getCities(let search_string, let page, let per_page),
                .getFavorites(let search_string, let page, let per_page):
            var params: [String: Any] = [:]//["order_direction":"ASC", "order_field":"name"]
            if let search_string = search_string, search_string.replacingOccurrences(of: " ", with: "") != "" {
                params["search_string"] = search_string
            }
            if let page = page {
                params["page"] = page
            }
            if let per_page = per_page {
                params["per_page"] = per_page
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getDetail(let id), .getDetailShort(let id):
            return .requestParameters(parameters: ["id":id], encoding: URLEncoding.default)
        case .getList(let ids, let page, let per_page):
            var params: [String: Any] = [:]
            if let ids = ids {
                params["ids"] = ids
            }
            if let page = page {
                params["page"] = page
            }
            if let per_page = per_page {
                params["per_page"] = per_page
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .addFavorite(let object_id):
            let params: [String: Any] = ["object_id":object_id]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .removeFavorite(let id):
            let params: [String: Any] = ["id":id]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .getListMap(let tl_lat, let tl_lon, let br_lat, let br_lon, let tr_lat, let tr_lon, let bl_lat, let bl_lon, let start_date, let end_date, let price_day_from, let price_day_to, let type_id, let rooms_counter, let bedrooms_counter, let feature_ids):
            var params: [String: Any] = ["tl_lat":tl_lat,
                                         "tl_lon":tl_lon,
                                         "br_lat":br_lat,
                                         "br_lon":br_lon,
                                         "tr_lat":tr_lat,
                                         "tr_lon":tr_lon,
                                         "bl_lat":bl_lat,
                                         "bl_lon":bl_lon]
            if let start_date = start_date {
                params["start_date"] = start_date
            }
            if let end_date = end_date {
                params["end_date"] = end_date
            }
            if let price_day_from = price_day_from {
                params["price_day_from"] = price_day_from
            }
            if let price_day_to = price_day_to {
                params["price_day_to"] = price_day_to
            }
            if !type_id.isEmpty {
                params["type_id"] = type_id
            }
            if !rooms_counter.isEmpty {
                params["rooms_counter"] = rooms_counter
            }
            if !feature_ids.isEmpty {
                params["feature_ids"] = feature_ids
            }
            if let bedrooms_counter = bedrooms_counter {
                params["guests_counter"] = bedrooms_counter
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        }
    }
}
    
