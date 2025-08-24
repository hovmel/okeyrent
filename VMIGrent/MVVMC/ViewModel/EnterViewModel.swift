//
//  EnterViewModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 01.06.2022.
//

import Foundation

final class EnterViewModel {
    
    var coordinator: EnterCoordinator?
    
    func registerEvent() {
        coordinator?.startRegister()
    }
    
}
