//
//  CodeViewModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 01.06.2022.
//

import RxSwift


enum CodeType {
    case auth
    case register
    case change
    
    var title: String {
        switch self {
        case .auth:
            return "code_title_enter".localized()
        case .register:
            return "code_title_register".localized()
        case .change:
            return "code_title_phone".localized()
        }
    }
    
    var isStep: Bool {
        switch self {
        case .auth, .change:
            return false
        case .register:
            return true
        }
    }
}

final class CodeViewModel {
    
    private let coordinator: CodeCoordinator
    private var service : RegisterService!
    private var authService : AuthService!
    private var profileService : ProfileService!
    
    let disposeBag = DisposeBag()
    var registerModel: RegisterModel! {
        didSet {
            self.phone = registerModel.phone
        }
    }
    var code: String = ""
    var phone: String = ""
    var view: CodeView!
    
    var timer: Timer?
    var timerCount: Int = 60
    
    var type: CodeType = .register
    
    init(coordinator: CodeCoordinator, view:  CodeView, type: CodeType) {
        self.service = RegisterService()
        self.authService = AuthService()
        self.profileService = ProfileService()
        self.type = type
        self.view = view
        self.coordinator = coordinator
    }
    
    func startTimer() {
        self.timerCount = 60
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        self.view.setResendTime(text: String(format: "code_resend_code_timer".localized(), arguments: ["\(self.timerCount)"]), isEnabled: false)
    }
    
    @objc func timerTick() {
        self.timerCount -= 1
        if self.timerCount == 0 {
            self.timer?.invalidate()
            self.view.setResendTime(text: "code_resend_code".localized(), isEnabled: true)
        } else {
            self.view.setResendTime(text: "Отправить код повторно (0:\(self.timerCount))", isEnabled: false)
        }
    }
    
    func registerEvent() {
        
    }
    
    func resendCode() {
        self.view.setupResendLoading(true)
        switch self.type {
        case .register:
            self.resendRegisterCode()
        case .auth:
            self.resendAuthCode()
        case .change:
            self.resendChangeCode()
        }
    }
    
    func sendCode() {
        self.view.setupLoading(true)
        switch self.type {
        case .register:
            self.sendRegisterCode()
        case .auth:
            self.sendAuthCode()
        case .change:
            self.sendChangeCode()
        }
    }
    
    private func resendChangeCode() {
        self.profileService.sendNewPhone(phone: self.phone).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupResendLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                switch response.status {
                case .success:
                    self.startTimer()
                case .error:
                    break
                case .failed:
                    break
                case .none:
                    break
                }
                return
            case .error(_):
                self.view.showError(message: "Не удалось отправить телефон")
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    private func sendChangeCode() {
        self.profileService.sendNewCode(phone: self.phone, code: self.code).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                if let message = response.message {
                    self.view.showError(message: message)
                } else {
                    self.view.openSuccessChangeNumber()
                }
                return
            case .error(let error):
                print(error)
                self.view.error()
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    private func sendAuthCode() {
        self.authService.checkPhone(code: self.code, phone: self.phone).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                if let token = response.token,
                   let tokenType = response.tokenType {
                    AuthManager.shared.setSessionToken(token: token, tokenType: tokenType)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.checkAppSession()
                    self.view.openMain()
                }
                return
            case .error(let error):
                print(error)
                self.view.error()
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    private func sendRegisterCode() {
        self.service.registerPhone(code: self.code, registerModel: self.registerModel).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                if let _ = response.message {
                    self.view.error()
                } else if let token = response.token,
                          let tokenType = response.tokenType {
                    AuthManager.shared.setSessionToken(token: token, tokenType: tokenType)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.checkAppSession()
                    self.view.openDocs()
                }
                return
            case .error(_):
                self.view.error()
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    private func resendAuthCode() {
        self.authService.sendPhone(phone: self.phone).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupResendLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                switch response.status {
                case .success:
                    self.startTimer()
                case .error:
                    break
                case .failed:
                    break
                case .none:
                    break
                }
                return
            case .error(_):
                self.view.showError(message: "Не удалось отправить телефон")
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    private func resendRegisterCode() {
        self.service.sendPhone(phone: self.phone).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupResendLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                switch response.status {
                case .success:
                    self.startTimer()
                case .error:
                    break
                case .failed:
                    break
                case .none:
                    break
                }
                return
            case .error(_):
                self.view.showError(message: "Не удалось отправить телефон")
                return
            }
        }.disposed(by: self.disposeBag)
    }
}
