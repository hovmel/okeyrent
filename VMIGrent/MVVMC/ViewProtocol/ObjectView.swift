//
//  ObjectView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 30.06.2022.
//

import Foundation

protocol ObjectView: AnyObject {
    func setupLoading(_ isLoading: Bool)
    func setupFavoriteLoading(_ isLoading: Bool)
    func setObject(_ object: ObjectModel, reviews: [ReviewModel])
    func showAuthAlert()
    func error(_ message: String)
}
