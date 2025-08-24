//
//  ReviewView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 22.07.2022.
//

import Foundation

protocol ReviewView: AnyObject {
    func setupLoading(_ isLoading: Bool)
    func setupButtonEnabled(_ isEnabled: Bool)
    func error(_ message: String)
    func openSuccess()
}
