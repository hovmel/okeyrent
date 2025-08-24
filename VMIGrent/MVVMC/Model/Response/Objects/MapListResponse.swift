//
//  MapListResponse.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 22.06.2022.
//

import Foundation

class MapListResponse: BaseResponse {
    
    var objects: [MapListItem]?
    var city: CityModel?
    var meta: MapMetaModel?
    
    private enum CodingKeys: String, CodingKey {
        case objects = "objects"
        case city
        case meta
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        objects = try container.decodeIfPresent(.objects)
        city = try container.decodeIfPresent(.city)
        meta = try container.decodeIfPresent(.meta)
        
        try super.init(from: decoder)
    }
    
}

