//
//  ObjectRulesCellModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 06.07.2022.
//

import Foundation

struct ObjectRulesCellModel {
    var startFromTime: String?
    var startToTime: String?
    var endTime: String?
    var descr: String?
    
    var isEmpty: Bool {
        return startFromTime == nil && startToTime == nil && endTime == nil && descr == nil
    }
}
