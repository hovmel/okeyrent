//
//  BookingsState.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 10.07.2022.
//

import Foundation

struct BookingsState: Decodable {
    var id: BookingsStateType
    var title: String
}

enum BookingsStateType: String, Decodable {
    case needPayment = "NEED_PAYMENT"
    case paymentPending = "PAYMENT_PENDING"
    case confirmPending = "CONFIRM_PENDING"
    case accepted = "ACCEPTED"
    case done = "DONE"
    case canceled = "CANCELED"
    case declined = "DECLINED"
}
