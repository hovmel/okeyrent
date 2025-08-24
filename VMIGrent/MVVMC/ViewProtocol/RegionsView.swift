//
//  RegionsView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 20.07.2022.
//

import Foundation

protocol RegionsView: AnyObject {
    func setupLoading(_ isLoading: Bool)
    func setCities(_ cities: [CityModel])
}
