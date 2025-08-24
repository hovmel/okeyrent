//
//  CodeProtocol.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.06.2022.
//

import Foundation

protocol CodeView: AnyObject {
    func error()
    func showError(message: String)
    func setupLoading(_ isLoading: Bool)
    func setupResendLoading(_ isLoading: Bool)
    func setResendTime(text: String, isEnabled: Bool)
    func openMain()
    func openSuccessChangeNumber()
    func openDocs()
}
