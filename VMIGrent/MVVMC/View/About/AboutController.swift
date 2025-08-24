//
//  AboutController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 08.06.2022.
//

import Foundation
import UIKit

class AboutController: UIViewController {
    
    class func openAboutController(viewController: UIViewController, agreement: String, politic: String) {
        let storyboard = UIStoryboard(name: "About", bundle: nil)
        var controllers: [UIViewController] = viewController.navigationController?.viewControllers ?? [viewController]
        let aboutController = storyboard.instantiateInitialViewController() as! AboutController
        aboutController.agreementLink = agreement
        aboutController.politicLink = politic
        controllers.append(aboutController)
        viewController.navigationController?.setViewControllers(controllers, animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var agreementLink: String!
    var politicLink: String!
    
    var profileMenus: [ProfileMenu] {
        return [.agreement, .politic, .version]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        self.commonSetup()
        self.commonTableViewSetup(tableView: self.tableView, cells: [ProfileMenuCellView.self, LogoCellView.self])
        self.tableView.separatorStyle = .singleLine
    }
    
}

extension AboutController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            if let url = URL(string: self.agreementLink) {
//                UIApplication.shared.open(url)
                WebController.openWebController(viewController: self, url: url, type: .simple)
            }
        case 2:
            if let url = URL(string: self.politicLink) {
//                UIApplication.shared.open(url)
                WebController.openWebController(viewController: self, url: url, type: .simple)
            }
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LogoCellView.self), for: indexPath) as? LogoCellView {
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileMenuCellView.self), for: indexPath) as? ProfileMenuCellView {
                cell.setupModel(ProfileMenuCellModel(title: self.profileMenus[indexPath.row-1].title))
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profileMenus.count + 1
    }
    
}
