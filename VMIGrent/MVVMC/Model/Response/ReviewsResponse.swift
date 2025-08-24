//
//  ReviewsResponse.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 20.07.2022.
//

import Foundation

class ReviewsResponse: BaseResponse {
    
    var items: [ReviewModel]?
    
    private enum CodingKeys: String, CodingKey {
        case items = "items"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decodeIfPresent(.items)
        
        try super.init(from: decoder)
    }

    
}
