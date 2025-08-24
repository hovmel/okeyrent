//
//  LockConfigModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 22.12.2022.
//

import Foundation

struct LockConfigModel {
    var serial: String
    var key: String
    var autoCloseTime: Int
    var directionID: DirectionIDType
}
