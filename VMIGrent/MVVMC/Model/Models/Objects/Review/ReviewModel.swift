//
//  ReviewModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 13.07.2022.
//

import Foundation

struct ReviewModel: Decodable {
    var id: Int
    var customer: OwnerModel
    var review: String?
    var rate: String
    var created_at: Int
}
