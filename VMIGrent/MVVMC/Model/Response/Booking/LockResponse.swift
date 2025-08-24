//
//  LockResponse.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 31.07.2022.
//

import Foundation

class LockResponse: BaseResponse {
    
    var lockSerialNumber: String?
    var lockKey: String?
    var directionID: DirectionIDType?
    var autoCloseTime: Int?
    
    var lockConfig: LockConfigModel {
        return LockConfigModel(serial: self.lockSerialNumber ?? "",
                               key: self.lockKey ?? "",
                               autoCloseTime: self.autoCloseTime ?? 0,
                               directionID: self.directionID ?? .left)
    }
    
    private enum CodingKeys: String, CodingKey {
        case lockSerialNumber = "lock_serial_number"
        case lockKey = "lock_key"
        case directionID = "direction_id"
        case autoCloseTime = "auto_close_time"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lockSerialNumber = try container.decodeIfPresent(.lockSerialNumber)
        lockKey = try container.decodeIfPresent(.lockKey)
        directionID = try container.decodeIfPresent(.directionID)
        autoCloseTime = try container.decodeIfPresent(.autoCloseTime)
        
        try super.init(from: decoder)
    }

}

enum DirectionIDType: String, Decodable {
    case left = "LEFT"
    case right = "RIGHT"
    
    var value: Int {
        switch self {
        case .left:
            return 1
        case .right:
            return 2
        }
    }
}
