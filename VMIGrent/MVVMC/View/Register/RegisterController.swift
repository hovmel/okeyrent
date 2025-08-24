//
//  RegisterController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 30.05.2022.
//

import Foundation
import UIKit

class RegisterController: UIViewController {
    
    class func openRegisterController(viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        var controllers: [UIViewController] = viewController.navigationController?.viewControllers ?? [viewController]
        let registerController = storyboard.instantiateViewController(withIdentifier: "RegisterController") as! RegisterController
        registerController.viewModel = RegisterViewModel(coordinator: RegisterCoordinator(navigationController: viewController.navigationController!),
                                                         view: registerController)
        controllers.append(registerController)
        viewController.navigationController?.setViewControllers(controllers, animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var agreementLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sendButton: CommonButton!
    
    var viewModel: RegisterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        self.commonSetup()
        self.agreementLabel.setColored(target: self,
                                       text: "Продолжая, вы принимаете условия пользовательского соглашения и политики конфиденциальности",
                                       subText: ["пользовательского соглашения", "политики конфиденциальности"],
                                       action: #selector(self.openAgreement(gesture:)))
        self.commonTableViewSetup(tableView: self.tableView, cells: [FieldCellView.self])
    }
    
    @IBAction func getCodePressed() {
        self.viewModel.registerEvent()
    }
    
}

extension RegisterController: RegisterView {
    
    func showError(message: String) {
        self.openErrorAlert(message: message)
    }
    
    func setupLoading(_ isLoading: Bool) {
        self.sendButton.setupLoading(isLoading)
    }
    
}

extension RegisterController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.registerCellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FieldCellView.self), for: indexPath) as? FieldCellView {
            cell.setupModel(self.viewModel.registerCellModels[indexPath.row])
            cell.fieldView.action = { [unowned self] text in
                switch indexPath.row {
                case 0:
                    self.viewModel.registerModel.name = text
                case 1:
                    self.viewModel.registerModel.secondName = text
                case 2:
                    self.viewModel.registerModel.phone = text
                default:
                    break
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
}
