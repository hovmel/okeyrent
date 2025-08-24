//
//  ProfileViewModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 06.06.2022.
//

import RxSwift

final class ProfileViewModel {
    
    private var service: ProfileService!
    
    var profile = CustomerModel()
    
    var passportPhoto: UIImage? {
        didSet {
            self.views.forEach({$0.updateDocuments(passport: self.passportPhoto, selfie: self.selfiePhoto)})
        }
    }
    var selfiePhoto: UIImage? {
        didSet {
            self.views.forEach({$0.updateDocuments(passport: self.passportPhoto, selfie: self.selfiePhoto)})
        }
    }
    
    let disposeBag = DisposeBag()
    var views: [ProfileView] = []
    
    init(view: ProfileView) {
        self.service = ProfileService()
        self.views.append(view)
    }
    
    func getProfile() {
        self.views.forEach({$0.setupLoading(true)})
        self.service.getProfile().subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.views.forEach({$0.setupLoading(false)})
            switch event {
            case .completed:
                return
            case .next(let response):
                self.profile = response
                self.views.forEach({$0.updateCustomer(response)})
                return
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    func logout() {
        self.views.forEach({$0.setupLoading(true)})
        self.service.logout().subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.views.forEach({$0.setupLoading(false)})
            switch event {
            case .completed:
                return
            case .next(let response):
                AuthManager.shared.removeUser()
                self.views.forEach({$0.logout()})
                return
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    func delete() {
        self.views.forEach({$0.setupLoading(true)})
        self.service.delete().subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.views.forEach({$0.setupLoading(false)})
            switch event {
            case .completed:
                return
            case .next(let response):
                if let message = response.errorText {
                    self.views.forEach({$0.error(message: message)})
                } else {
                    AuthManager.shared.removeUser()
                    self.views.forEach({$0.logout()})
                }
                return
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    func updateProfile(_ template: TemplateProfile) {
        self.views.forEach({$0.setupLoading(true)})
        self.service.updateProfile(profile: template).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.views.forEach({$0.setupLoading(false)})
            switch event {
            case .completed:
                return
            case .next(let response):
                if let message = response.errorText {
                    self.views.forEach({$0.error(message: message)})
                } else {
                    self.profile = response
                    self.views.forEach({$0.updateCustomer(response)})
                    self.views.forEach({$0.openUpdateSuccessAlert()})
                }
                return
            case .error(_):
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    func sendDocuments() {
        guard let id = self.profile.id else {return}
        self.views.forEach({$0.setupLoading(true)})
        self.service.sendDocuments(id: id,
                                   passport: self.passportPhoto!,
                                   selfie: self.selfiePhoto!).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.views.forEach({$0.setupLoading(false)})
            switch event {
            case .completed:
                return
            case .next(let response):
                if let message = response.message {
                    self.views.forEach({$0.error(message: message)})
                } else {
                    self.profile = response
                    self.views.forEach({$0.updateCustomer(response)})
                    self.views.forEach({$0.openDocumentSuccessAlert()})
                }
                return
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
}
