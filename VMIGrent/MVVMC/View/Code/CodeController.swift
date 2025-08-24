//
//  CodeController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 01.06.2022.
//

import UIKit

fileprivate let resend_bottom_constr: CGFloat = 24.0

class CodeController: KeyboardController {
    
    class func openCodeController(viewController: UIViewController, phone: String, type: CodeType) {
        let storyboard = UIStoryboard(name: "Code", bundle: nil)
        var controllers: [UIViewController] = viewController.navigationController?.viewControllers ?? [viewController]
        let codeController = storyboard.instantiateViewController(withIdentifier: "CodeController") as! CodeController
        codeController.viewModel = CodeViewModel(coordinator: CodeCoordinator(navigationController: viewController.navigationController!), view: codeController, type: type)
        codeController.viewModel.phone = phone
        controllers.append(codeController)
        viewController.navigationController?.setViewControllers(controllers, animated: true)
    }
    
    @IBOutlet weak var codeView: CodeNumberView!
    @IBOutlet weak var bottomResendConstr: NSLayoutConstraint!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var resendCodeButton: MainButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    
    var viewModel: CodeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.viewModel.startTimer()
        self.titleLabel.text = self.viewModel.type.title
        self.stepLabel.isHidden = !self.viewModel.type.isStep
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.codeView.tmpTextField.becomeFirstResponder()
    }
    
    private func setupUI() {
        self.codeView.numberOfBlocks = 6
        self.codeView.delegate = self
        self.phoneLabel.text = "Мы отправили код на номер " + self.viewModel.phone
        self.commonSetup()
    }
    
    override func changeKeyboardHeight(_ keyboardHeight: CGFloat) {
        self.bottomResendConstr.constant = keyboardHeight + resend_bottom_constr
    }
    
    @IBAction func changePressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendPressed() {
        self.viewModel.resendCode()
    }
    
}

extension CodeController: CodeView {
    
    func openSuccessChangeNumber() {
        self.openInfoAlert(title: "Номер успешно изменен", rightAction: { [unowned self] in
            NotificationCenter.default.post(name: .updateProfile, object: nil)
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    func showError(message: String) {
        self.openErrorAlert(message: message)
    }
    
    func setupResendLoading(_ isLoading: Bool) {
        self.resendCodeButton.setupLoading(isLoading)
    }
    
    func error() {
        self.codeView.shake()
    }
    
    func setupLoading(_ isLoading: Bool) {
        if isLoading {
            self.loader.startAnimating()
        } else {
            self.loader.stopAnimating()
        }
        self.codeView.isHidden = isLoading
    }
    
    func setResendTime(text: String, isEnabled: Bool) {
        self.resendCodeButton.setTitle(text, for: .normal)
        self.resendCodeButton.isEnabled = isEnabled
    }
    
    func openDocs() {
        DocumentsController.openDocumentsController(viewController: self, viewModel: nil, isStep: true)
    }
}

extension CodeController: CodeNumberViewDelegate {
    func didEnterAllDigits(_ codeString: String, confirmationView: CodeNumberView) {
        self.viewModel.code = codeString
        self.viewModel.sendCode()
    }
}
