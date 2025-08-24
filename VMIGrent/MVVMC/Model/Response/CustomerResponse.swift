//
//  CustomerResponse.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 05.06.2022.
//

import Foundation

class CustomerResponse: BaseResponse {
    
    var customer: CustomerModel?
    
    private enum CodingKeys: String, CodingKey {
        case customer = "customer"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        customer = try container.decodeIfPresent(.customer)
        
        try super.init(from: decoder)
    }

    
}



