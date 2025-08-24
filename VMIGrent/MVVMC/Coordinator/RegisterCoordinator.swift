//
//  RegisterCoordinator.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 30.05.2022.
//

import Foundation
import UIKit
  
final class RegisterCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let registerController: RegisterController = .instantiate(sbName: "Register")
        let registerViewModel: RegisterViewModel = RegisterViewModel(coordinator: self, view: registerController)
        registerController.viewModel = registerViewModel
        navigationController.show(registerController, sender: self)
    }
    
    func startCode(registerModel: RegisterModel) {
        let codeCoordinator = CodeCoordinator(navigationController: self.navigationController)
        childCoordinators.append(codeCoordinator)
        codeCoordinator.start(registerModel: registerModel)
    }
    
}
