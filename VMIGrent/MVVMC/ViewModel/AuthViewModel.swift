//
//  AuthViewModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 05.06.2022.
//

import Foundation
import RxSwift

final class AuthViewModel {
    
//    private let coordinator: CodeCoordinator
    private var service : AuthService!
    private var profileService : ProfileService!
    
    let disposeBag = DisposeBag()
    var phone: String = ""
    var view: AuthView!
    var type: AuthType = .auth
    
    init(view: AuthView, type: AuthType) {
        self.service = AuthService()
        self.profileService = ProfileService()
        self.type = type
        self.view = view
    }
    
    func sendPhone() {
        switch self.type {
        case .auth:
            self.sendAuthPhone()
        case .change:
            self.sendChangePhone()
        }
    }
    
    private func sendChangePhone() {
        self.view.setupLoading(true)
        self.profileService.sendNewPhone(phone: self.phone).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                if let message = response.errorText {
                    self.view.error(message: message)
                } else {
                    self.view.openCode(self.phone)
                }
                return
            case .error(_):
                self.view.error(message: "Не удалось отправить телефон")
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    private func sendAuthPhone() {
        self.view.setupLoading(true)
        self.service.sendPhone(phone: self.phone).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                if let message = response.errorText {
                    self.view.error(message: message)
                } else {
                    self.view.openCode(self.phone)
                }
                return
            case .error(_):
                self.view.error(message: "Не удалось отправить телефон")
                return
            }
        }.disposed(by: self.disposeBag)
    }
}
