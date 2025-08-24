//
//  DashboardResponse.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 13.07.2022.
//

import Foundation

class DashboardResponse: BaseResponse {
    
    var cities: [CityModel]
    var objects: [ObjectShortModel]
    
    private enum CodingKeys: String, CodingKey {
        case cities = "cities"
        case objects = "objects"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cities = try container.decode(.cities)
        objects = try container.decode(.objects)
        
        try super.init(from: decoder)
    }

    
}




