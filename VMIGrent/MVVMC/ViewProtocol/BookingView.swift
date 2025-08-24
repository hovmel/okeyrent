//
//  BookingView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.07.2022.
//

import Foundation

protocol BookingView: AnyObject {
    func setupLoading(_ isLoading: Bool)
    func setupCalculateLoading(_ isLoading: Bool)
    func calculateError(message: String)
    func setupInfo(object: ObjectModel, booking: BookingModel)
    func openPayment(url: URL)
    func error(message: String)
}
