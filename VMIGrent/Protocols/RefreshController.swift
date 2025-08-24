//
//  RefreshController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 02.08.2022.
//

import Foundation
import UIKit

protocol RefreshController: AnyObject {
    var refreshControl: UIRefreshControl {get}
    func addRefresh(tableView: UITableView)
    func refreshAction()
    func setRefreshLoading(_ isLoading: Bool)
}

extension RefreshController where Self: UIViewController {
    var refreshControl: UIRefreshControl {
        get {
            return UIRefreshControl()
        }
    }
    
    func addRefresh(tableView: UITableView) {
        tableView.addSubview(self.refreshControl)
    }
    
    func setRefreshLoading(_ isLoading: Bool) {
        isLoading ? self.refreshControl.beginRefreshing() : self.refreshControl.endRefreshing()
    }
}
