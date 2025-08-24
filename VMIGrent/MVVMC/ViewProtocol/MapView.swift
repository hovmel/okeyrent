//
//  MapView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 17.06.2022.
//

import Foundation
import CoreLocation

protocol MapView: AnyObject {
    func setupLoading(_ isLoading: Bool)
    func setupListLoading(_ isLoading: Bool)
    func setupMoreListLoading(_ isLoading: Bool)
    func setupFavoriteLoading(id: Int?, objects: [ObjectShortModel]?, listObjects: [ObjectShortModel]?)
    func zoomMap(coor: CLLocationCoordinate2D)
    func setupCity(name: String)
    func setupObjects(_ objects: [MapListItem], count: Int)
    func setupListObjects(_ objects: [ObjectShortModel])
    func showAlert(title: String, message: String)
    func showAuthAlert()
    func showObjectsMap(_ objects: [ObjectShortModel])
    func error(message: String)
}
