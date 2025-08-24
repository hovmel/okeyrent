//
//  CodeCoordinator.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 01.06.2022.
//

import Foundation
import UIKit

final class CodeCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(registerModel: RegisterModel) {
        let codeController: CodeController = .instantiate(sbName: "Code")
        let codeViewModel: CodeViewModel = CodeViewModel(coordinator: self, view: codeController, type: .register)
        codeViewModel.registerModel = registerModel
        codeController.viewModel = codeViewModel
        navigationController.show(codeController, sender: self)
    }
    
    func start() {
        
    }
    
}
