//
//  BookingDetailView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 11.07.2022.
//

import Foundation

protocol BookingDetailView: AnyObject {
    func setupLoading(_ isLoading: Bool)
    func setupLoadingLock(_ isLoading: Bool)
    func setupLoadingUnlock(_ isLoading: Bool)
    func setupFavoriteLoading(_ isLoading: Bool)
    func setupBooking(_ booking: BookingModel)
    func error(_ message: String)
    func endSuccess()
    func connectLock(_ lockModel: LockConfigModel)
    func openLock()
    func closeLock()
    func hideLock(_ isHide: Bool)
}
