//
//  ObjectShortModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 17.06.2022.
//

import Foundation

struct ObjectShortModel: Decodable {
    var id: Int
    var area: Int
    var roomsCounter: Int
    var guestsCounter: Int
    var bedroomsCounter: Int
    var bedsCounter: Int
    var rate: Double
    var pictures: [ObjectPictureModel]?
    var picture: PictureModel?
    var priceDay: Int
    var address: String
    var latitude: Double
    var longitude: Double
    var inFavorite: Bool
    var favoriteID: Int?
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case area
        case roomsCounter = "rooms_counter"
        case guestsCounter = "guests_counter"
        case bedroomsCounter = "bedrooms_counter"
        case bedsCounter = "beds_counter"
        case rate
        case picture
        case priceDay = "price_day"
        case address
        case latitude
        case longitude
        case inFavorite = "in_favorite"
        case favoriteID = "favorite_id"
        case pictures
        case name
    }
    
}
