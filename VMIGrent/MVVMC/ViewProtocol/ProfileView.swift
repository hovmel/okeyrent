//
//  ProfileView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 06.06.2022.
//

import Foundation
import UIKit

protocol ProfileView: AnyObject {
    func error(message: String)
    func openUpdateSuccessAlert()
    func openDocumentSuccessAlert()
    func setupLoading(_ isLoading: Bool)
    func updateCustomer(_ customer: CustomerModel)
    func updateDocuments(passport: UIImage?, selfie: UIImage?)
    func logout()
}

extension ProfileView {
    func openUpdateSuccessAlert() {}
    func openDocumentSuccessAlert() {}
    func error(message: String) {}
    func setupLoading(_ isLoading: Bool) {}
    func updateCustomer(_ customer: CustomerModel) {}
    func updateDocuments(passport: UIImage?, selfie: UIImage?) {}
    func logout() {}
}
