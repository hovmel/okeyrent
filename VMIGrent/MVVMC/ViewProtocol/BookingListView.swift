//
//  BookingListView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 11.07.2022.
//

import Foundation

protocol BookingListView: AnyObject {
    func error(_ message: String)
    func setupLoading(_ isLoading: Bool)
    func setupFavoriteLoading(_ id: Int?)
    func setupBookings(_ bookings: [BookingModel])
}
