//
//  AppCoordinator.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 25.05.2022.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] {get}
    func start()
}

final class AppCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    
    func start() {
        if let _ = AuthManager.shared.getSessionToken() {
            let sb = UIStoryboard(name: "Load", bundle: nil)
            let controller = sb.instantiateInitialViewController()
            window.rootViewController = controller
        } else {
            let navigationController = UINavigationController()
            let enterCoordinator = EnterCoordinator(navigationController: navigationController)
            enterCoordinator.start()
            childCoordinators.append(enterCoordinator)
            window.rootViewController = navigationController
        }
        window.makeKeyAndVisible()
    }
    
    init(window: UIWindow) {
        self.window = window
    }
    
}
