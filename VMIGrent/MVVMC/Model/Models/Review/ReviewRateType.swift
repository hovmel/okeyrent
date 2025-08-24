//
//  ReviewRateType.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 16.07.2022.
//

import Foundation

enum ReviewRateType: String, Encodable, Decodable, CaseIterable {
    case CLEAN
    case CHECK_IN
    case LOCATION
    case PRICE_QUALITY
    
    var title: String {
        switch self {
        case .CLEAN:
            return "Чистота"
        case .CHECK_IN:
            return "Удобство заселения"
        case .LOCATION:
            return "Местоположение"
        case .PRICE_QUALITY:
            return "Цена/качество"
        }
    }
}
