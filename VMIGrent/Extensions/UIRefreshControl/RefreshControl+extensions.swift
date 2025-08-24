//
//  RefreshControl+extensions.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 02.08.2022.
//

import Foundation
import UIKit

extension UIRefreshControl {
    func setLoading(_ isLoading: Bool) {
        isLoading ? self.beginRefreshing() : self.endRefreshing()
    }
}
