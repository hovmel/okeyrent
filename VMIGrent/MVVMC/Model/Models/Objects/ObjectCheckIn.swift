//
//  ObjectCheckInModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 17.06.2022.
//

import Foundation

enum ObjectCheckIn: String, Decodable {
    case owner = "OWNER"
    case autolock = "AUTOLOCK"
}
