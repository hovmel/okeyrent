//
//  BookingEndView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 13.07.2022.
//

import Foundation

protocol BookingEndView: AnyObject {
    func setupLoading(_ isLoading: Bool)
    func openSuccess()
    func openAlert(message: String)
    func error(_ message: String)
}

