//
//  AuthResponse.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 06.06.2022.
//

import Foundation

class AuthResponse: BaseResponse {
    
    var customer: CustomerModel?
    var tokenType: String?
    var token: String?
    
    private enum CodingKeys: String, CodingKey {
        case customer = "customer"
        case tokenType = "token_type"
        case token = "token"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        customer = try container.decodeIfPresent(.customer)
        tokenType = try container.decodeIfPresent(.tokenType)
        token = try container.decodeIfPresent(.token)
        try super.init(from: decoder)
    }
    
}
