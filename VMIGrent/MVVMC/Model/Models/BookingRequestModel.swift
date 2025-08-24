//
//  BookingRequestModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.07.2022.
//

import Foundation

struct BookingRequestModel {
    let df: DateFormatter = DateFormatter.yyyyMMdd
    let tf: DateFormatter = DateFormatter.hoursAndMnutes
    
    var id: Int
    var comment: String?
    var startDate: Date?
    var endDate: Date?
    var startTime: Date?
    var endTime: Date?
    
    var startDateStr: String {
        if let startDate = startDate {
            return df.string(from: startDate)
        }
        return ""
    }
    
    var endDateStr: String {
        if let endDate = endDate {
            return df.string(from: endDate)
        }
        return ""
    }
    
    var startTimeStr: String {
        if let startTime = startTime {
            return tf.string(from: startTime)
        }
        return ""
    }
    
    var endTimeStr: String {
        if let endTime = endTime {
            return tf.string(from: endTime)
        }
        return ""
    }
}
