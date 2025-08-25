//
//  BookingAPI.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.07.2022.
//

import Foundation
import Moya

enum BookingAPI: BaseAPI {
    case getDetail(Int)
    case getList(Int, Int)
    case createBooking(Int,String?,String,String,String,String)
    case calculateBooking(Int,String?,String,String,String,String)
    case cancelBooking(Int)
    case finishBooking(Int)
    case openLock(Int)
    case closeLock(Int)
    case getLock(Int)
}

extension BookingAPI {
    
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


extension BookingAPI: TargetType {
    
    var path: String {
        switch self {
        case .getDetail:
            return "/bookings/detail"
        case .getList:
            return "/bookings/list"
        case .createBooking:
            return "/bookings/create"
        case .calculateBooking:
            return "/bookings/calculate"
        case .cancelBooking:
            return "/bookings/cancel"
        case .finishBooking:
            return "/bookings/finish"
        case .openLock:
            return "/bookings/lock-open"
        case .closeLock:
            return "/bookings/lock-close"
        case .getLock:
            return "/bookings/lock-detail"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getDetail, .getList:
            return .get
        case .createBooking, .calculateBooking, .cancelBooking, .finishBooking, .openLock, .closeLock, .getLock:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getDetail(let id):
            let params: [String: Any] = ["id": id]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getList(let page, let perPage):
            let params: [String: Any] = [
                                         "order_field": "state_id_start_date",
                                         "order_fields": ["NEED_PAYMENT","PAYMENT_PENDING","CONFIRM_PENDING","ACCEPTED","DONE","CANCELED","DECLINED"],
                                         "order_direction": "DESC",
                                         "page": page,
                                         "per_page": perPage]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .createBooking(let object_id, let comment, let start_date, let end_date, let start_time, let end_time),
                .calculateBooking(let object_id, let comment, let start_date, let end_date, let start_time, let end_time):
            var params: [String: Any] = ["object_id":object_id,
                                         "start_date":start_date,
                                         "end_date":end_date,
                                         "start_time":start_time,
                                         "end_time":end_time,
                                         "guests_counter":1]
            if let comment = comment {
                params["comment"] = comment
            }
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .cancelBooking(let id), .finishBooking(let id), .openLock(let id), .closeLock(let id), .getLock(let id):
            let params: [String: Any] = ["id": id]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
}
    
