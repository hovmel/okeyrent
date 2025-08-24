//
//  PictureModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 17.06.2022.
//

import Foundation

struct PictureModel: Decodable {
    var original: String
    var m50: String?
    var m100: String?
    
    enum CodingKeys: String, CodingKey {
        case original
        case m50 = "50"
        case m100 = "100"
    }
}
