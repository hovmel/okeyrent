//
//  BaseResponse.swift
//  GLC
//
//  Created by Михаил on 05.09.2018.
//  Copyright © 2018 Duotek. All rights reserved.
//

import Foundation

enum ResponseStatus: String, Codable {
    case success
    case error
    case failed
}

class BaseResponse: Decodable {
    var status: ResponseStatus?
    var errors: ErrorModel?
    var message: String?
    
    var errorText: String? {
        if let message = message {
            if let errors = errors, let phone = errors.phone?.first {
                return phone
            } else if let errors = errors, let email = errors.email?.first {
                return email
            } else {
                return message
            }
        }
        return nil
    }
    
    private enum CodingKeys: String, CodingKey { case status, errors, message }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(.status)
        errors = try container.decodeIfPresent(.errors)
        message = try container.decodeIfPresent(.message)
    }
}


struct ErrorModel: Decodable {
    var phone: [String]?
    var email: [String]?
}
