//
//  OwnerModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.07.2022.
//

import Foundation

struct OwnerModel: Decodable {
    var id: Int
    var name: String
    var first_name: String?
    var last_name: String?
    var phone: String?
    var picture: PictureModel?
    var rate: Double?
}
