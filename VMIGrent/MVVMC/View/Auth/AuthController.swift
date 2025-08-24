//
//  AuthController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 05.06.2022.
//

import Foundation
import UIKit

enum AuthType {
    case auth
    case change
    
    var title: String {
        switch self {
        case .auth:
            return "Вход"
        case .change:
            return "Изменить номер телефона"
        }
    }
    
    var codeType: CodeType {
        switch self {
        case .auth:
            return .auth
        case .change:
            return .change
        }
    }
}

class AuthController: UIViewController {
    
    class func openAuthController(viewController: UIViewController, type: AuthType) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        var controllers: [UIViewController] = viewController.navigationController?.viewControllers ?? [viewController]
        let authController = storyboard.instantiateViewController(withIdentifier: "AuthController") as! AuthController
        authController.viewModel = AuthViewModel(view: authController, type: type)
        controllers.append(authController)
        viewController.navigationController?.setViewControllers(controllers, animated: true)
    }
    
    @IBOutlet weak var agreementLabel: UILabel!
    @IBOutlet weak var phoneFieldView: FieldView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sendButton: CommonButton!
    
    var viewModel: AuthViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonSetup()
        self.agreementLabel.setColored(target: self,
                                       text: "Продолжая, вы принимаете условия пользовательского соглашения и политики конфиденциальности",
                                       subText: ["пользовательского соглашения", "политики конфиденциальности"],
                                       action: #selector(self.openAgreement(gesture:)))
        self.phoneFieldView.type = .phone
        self.phoneFieldView.action = { [unowned self] text in
            self.viewModel.phone = text
        }
        self.titleLabel.text = self.viewModel.type.title
        self.phoneFieldView.titleLabel.text = "Укажите номер телефона, на него придет код подтверждения"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.phoneFieldView.phoneField.becomeFirstResponder()
    }
    
    @IBAction func sendPressed() {
        self.viewModel.sendPhone()
    }
    
}

extension AuthController: AuthView {
    
    func error(message: String) {
        self.openErrorAlert(message: message)
    }
    
    func openCode(_ phone: String) {
        CodeController.openCodeController(viewController: self, phone: self.viewModel.phone, type: self.viewModel.type.codeType)
    }
    
    func setupLoading(_ isLoading: Bool) {
        self.sendButton.setupLoading(isLoading)
    }
    
}
