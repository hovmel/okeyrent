//
//  ObjectDetailShortResponse.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 17.06.2022.
//

import Foundation

class ObjectDetailShortResponse: BaseResponse {
    
    var data: ObjectShortModel?
    
    private enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decodeIfPresent(.data)
        
        try super.init(from: decoder)
    }

    
}

