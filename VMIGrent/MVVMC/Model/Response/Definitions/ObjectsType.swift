//
//  ObjectsType.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 28.06.2022.
//

import Foundation

enum ObjectsType: String, Decodable {
    case flat = "FLAT"
    case apartment = "APARTMENT"
    case house = "HOUSE"
    case hotelRoom = "HOTEL_ROOM"
    case hostel = "HOSTEL"
    case unique = "UNIQUE"
    case room = "ROOM"
}
