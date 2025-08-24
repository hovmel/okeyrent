//
//  FavoritesView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 11.07.2022.
//

import Foundation

protocol FavoritesView: AnyObject {
    func setupLoading(_ isLoading: Bool)
    func error(_ message: String)
    func setupFavoriteLoading(_ isLoading: Bool, id: Int?)
    func setupFavorites(_ objects: [ObjectShortModel])
}
