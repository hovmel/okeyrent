//
//  Notification+extensions.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 11.06.2022.
//

import Foundation
import UIKit

extension Notification.Name {
    static let closeMenu = Notification.Name("closeMenu")
    static let openMenu = Notification.Name("openMenu")
    static let openMap = Notification.Name("openMap")
    static let updateProfile = Notification.Name("updateProfile")
    static let openedBookings = Notification.Name("openedBookings")
    static let openedFavorites = Notification.Name("openedFavorites")
}
