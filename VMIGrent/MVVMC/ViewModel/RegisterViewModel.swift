//
//  RegisterViewModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 30.05.2022.
//

import Foundation
import RxSwift
import Moya

//FIXME: - 
//let moyaPlugins: [PluginType] = [NetworkLoggerPlugin(verbose: true, cURL: true)]
let moyaPlugins: [PluginType] = [NetworkLoggerPlugin()]

final class RegisterViewModel {
    
    private let coordinator: RegisterCoordinator
    var registerModel: RegisterModel = RegisterModel()
    
    let disposeBag = DisposeBag()
    var service: RegisterService!
    
    var view: RegisterView!
    
    init(coordinator: RegisterCoordinator, view: RegisterView) {
        self.service = RegisterService()
        self.view = view
        self.coordinator = coordinator
    }
    
    var registerCellModels: [RegisterCellModel] {
        return [RegisterCellModel(title: "register_1_field_name".localized(), value: self.name, type: .simple(.simple)),
                RegisterCellModel(title: "register_1_field_secondName".localized(), value: self.secondName, type: .simple(.simple)),
                RegisterCellModel(title: "register_1_field_phone".localized(), value: self.phone, type: .phone)]
    }
  
    var name: String {
        return registerModel.name
    }
    
    var secondName: String {
        return registerModel.secondName
    }
    
    var phone: String {
        return registerModel.phone
    }
    
    func registerEvent() {
        if self.name.replacingOccurrences(of: " ", with: "") != "",
            self.secondName.replacingOccurrences(of: " ", with: "") != "",
            self.phone.count == 16 {
            self.sendPhone()
        } else {
            self.view.showError(message: "register_error".localized())
        }
    }
    
    func sendPhone() {
        self.view.setupLoading(true)
        self.service.sendPhone(phone: phone).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                if let message = response.errorText {
                    self.view.showError(message: message)
                } else {
                    self.coordinator.startCode(registerModel: self.registerModel)
                }
            case .error(_):
                self.view.showError(message: "sms_error".localized())
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
}
