//
//  CitiesView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 20.06.2022.
//

import Foundation

protocol CitiesView: AnyObject {
    func setupLoading(_ isLoading: Bool)
    func setCities(_ cities: [CityModel])
    func setObjects(_ objects: [ObjectShortModel])
}
