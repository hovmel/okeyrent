//
//  AuthView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 05.06.2022.
//

import Foundation

protocol AuthView: AnyObject {
    func error(message: String)
    func openCode(_ phone: String)
    func setupLoading(_ isLoading: Bool)
}
