//
//  RegisterView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.06.2022.
//

import Foundation

protocol RegisterView: AnyObject {
    func showError(message: String)
    func setupLoading(_ isLoading: Bool)
}
