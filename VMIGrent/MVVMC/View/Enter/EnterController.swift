//
//  EnterController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 25.05.2022.
//

import Foundation
import UIKit

class EnterController: UIViewController {
    
    class func openEnterController(viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Enter", bundle: nil)
        var controllers: [UIViewController] = viewController.navigationController?.viewControllers ?? [viewController]
        let enterController = storyboard.instantiateInitialViewController() as! EnterController
        controllers.append(enterController)
        viewController.navigationController?.setViewControllers(controllers, animated: true)
    }
    
    @IBOutlet weak var backButton: UIButton!
    
    var viewModel: EnterViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = Colors.white
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.tintColor = Colors.mainBlack
//        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.viewModel = EnterViewModel()
        NotificationCenter.default.post(name: .closeMenu, object: nil)
        self.backButton.setImage(UIImage(named: "back_arrow")!.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    @IBAction func registerPressed() {
        RegisterController.openRegisterController(viewController: self)
        navigationController?.setNavigationBarHidden(false, animated: true)
//        self.viewModel.registerEvent()
    }
    
    @IBAction func authPressed() {
        AuthController.openAuthController(viewController: self, type: .auth)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func backPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
