//
//  MainController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 06.06.2022.
//

import Foundation
import UIKit

class MainController: UIViewController {
    
    class func openMainController(viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainController = storyboard.instantiateInitialViewController()!
        viewController.navigationController?.setViewControllers([mainController], animated: true)
    }
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var menuView: MenuView!
    @IBOutlet var containers: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.f2f2f2
        self.menuView.alpha = 1
        NotificationCenter.default.addObserver(self, selector: #selector(self.openMenu), name: .openMenu, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.closeMenu), name: .closeMenu, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.openMap), name: .openMap, object: nil)
        self.menuView.action = { menuItem in
            self.changeMenu(menuItem)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func changeMenu(_ menuItem: MenuElement) {
        self.containers.forEach({$0.alpha = 0})
        self.menuView.setSelected(index: menuItem.rawValue)
        switch menuItem {
        case .profile:
            self.containers[3].alpha = 1
        case .book:
            NotificationCenter.default.post(name: .openedBookings, object: nil)
            self.containers[2].alpha = 1
        case .favorite:
            NotificationCenter.default.post(name: .openedFavorites, object: nil)
            self.containers[1].alpha = 1
        case .search:
            self.containers[0].alpha = 1
        }
    }
    
    @objc func openMap() {
        self.changeMenu(.search)
    }
    
    @objc func openMenu() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else {return}
            self.mainStackView.alpha = 1
        }
    }
    
    @objc func closeMenu() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else {return}
            self.mainStackView.alpha = 0
        }
    }
    
    @IBAction func enterPressed() {
        self.openEnterController()
    }
    
}
