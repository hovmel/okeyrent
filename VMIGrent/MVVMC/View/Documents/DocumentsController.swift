//
//  DocumentsController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 26.06.2022.
//

import Foundation
import UIKit

class DocumentsController: UIViewController {
    
    class func openDocumentsController(viewController: UIViewController, viewModel: ProfileViewModel?, isStep: Bool) {
        let storyboard = UIStoryboard(name: "Documents", bundle: nil)
        let documentsController = storyboard.instantiateInitialViewController() as! DocumentsController
        if let viewModel = viewModel {
            documentsController.viewModel = viewModel
        } else {
            documentsController.viewModel = ProfileViewModel(view: documentsController)
        }
        var controllers: [UIViewController] = viewController.navigationController?.viewControllers ?? [viewController]
        controllers.append(documentsController)
        documentsController.isStep = isStep
        viewController.navigationController?.setViewControllers(controllers, animated: true)
    }
    
    @IBOutlet weak var passportView: DocumentView!
    @IBOutlet weak var selfieView: DocumentView!
    @IBOutlet weak var actionButton: CommonButton!
    @IBOutlet weak var skipButton: MainButton!
    
    var viewModel: ProfileViewModel!
    var isStep: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonSetup()
        self.setupUI()
        self.viewModel.views.append(self)
    }
    
    private func setupUI() {
        self.navigationItem.setHidesBackButton(self.isStep, animated: false)
        self.actionButton.isEnabled = self.viewModel.selfiePhoto != nil && self.viewModel.passportPhoto != nil
        self.skipButton.isHidden = !self.isStep
        self.passportView.type = .passport
        self.selfieView.type = .selfie
        self.passportView.action = { [unowned self] in
            CameraViewController.openCameraViewController(viewController: self, type: .passport, viewModel: self.viewModel)
        }
        self.selfieView.action = { [unowned self] in
            CameraViewController.openCameraViewController(viewController: self, type: .selfie, viewModel: self.viewModel)
        }
    }
    
    @IBAction func sendPressed() {
        self.viewModel.sendDocuments()
    }
    
    @IBAction func skipPressed() {
        self.openMain()
    }
    
}

extension DocumentsController: ProfileView {
    
    func openDocumentSuccessAlert() {
        InfoController.openInfoController(viewController: self, type: .time)
    }
    
    func error(message: String) {
        self.openErrorAlert(message: message)
    }
    
    func setupLoading(_ isLoading: Bool) {
        self.actionButton.setupLoading(isLoading)
    }
    
    func updateDocuments(passport: UIImage?, selfie: UIImage?) {
        self.passportView.imageView.image = passport
        self.selfieView.imageView.image = selfie
        self.actionButton.isEnabled = passport != nil && selfie != nil
    }
    
}
