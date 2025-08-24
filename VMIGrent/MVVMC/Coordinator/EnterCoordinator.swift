//
//  EnterCoordinator.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 01.06.2022.
//

import Foundation
import UIKit

class EnterCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let enterController: EnterController = .instantiate(sbName: "Enter")
        let enterViewModel = EnterViewModel()
        enterViewModel.coordinator = self
        enterController.viewModel = enterViewModel
        navigationController.setViewControllers([enterController], animated: false)
    }
    
    func startRegister() {
        let registerCoordinator = RegisterCoordinator(navigationController: self.navigationController)
        childCoordinators.append(registerCoordinator)
        registerCoordinator.start()
    }
    
    
}
