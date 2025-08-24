//
//  ObjectListResponse.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 25.06.2022.
//

import Foundation

class ObjectListResponse: BaseResponse {
    
    var items: [ObjectShortModel]?
    var meta: MetaModel?
    
    private enum CodingKeys: String, CodingKey {
        case items = "items"
        case meta
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decodeIfPresent(.items)
        meta = try container.decodeIfPresent(.meta)
        
        try super.init(from: decoder)
    }
    
}
