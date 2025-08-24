//
//  ProfileInformation.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 08.06.2022.
//

import Foundation
import UIKit

class ProfileInformationController: KeyboardController {
    
    class func openProfileInformationController(viewController: UIViewController, viewModel: ProfileViewModel) {
        let storyboard = UIStoryboard(name: "ProfileInformation", bundle: nil)
        var controllers: [UIViewController] = viewController.navigationController?.viewControllers ?? [viewController]
        let profileInformationController = storyboard.instantiateInitialViewController() as! ProfileInformationController
        viewModel.views.append(profileInformationController)
        profileInformationController.viewModel = viewModel
        controllers.append(profileInformationController)
        viewController.navigationController?.setViewControllers(controllers, animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionButton: CommonButton!
    
    var viewModel: ProfileViewModel!
    
    var templateProfile: TemplateProfile! {
        didSet {
            self.actionButton.isEnabled = true
        }
    }
    
    var registerCellModels: [RegisterCellModel] {
        let customer = self.viewModel.profile
        return [RegisterCellModel(title: "Имя".localized(),
                                  value: customer.firstName ?? "",
                                  type: .simple(.simple),
                                  isEnabled: true),
                RegisterCellModel(title: "Фамилия".localized(),
                                  value: customer.lastName ?? "",
                                  type: .simple(.simple),
                                  isEnabled: true),
                RegisterCellModel(title: "Дата рождения".localized(),
                                  value: customer.birthDate ?? "",
                                  type: .simple(.date),
                                  isEnabled: true),
                RegisterCellModel(title: "E-mail".localized(),
                                  value: customer.email ?? "",
                                  type: .simple(.email),
                                  isEnabled: true)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.templateProfile = self.viewModel.profile.templateProfile
        self.setupUI()
    }
    
    override func changeKeyboardHeight(_ keyboardHeight: CGFloat) {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    }
    
    private func setupUI() {
        self.actionButton.isEnabled = false
        self.commonSetup()
        self.commonTableViewSetup(tableView: self.tableView, cells: [FieldCellView.self, ProfileImageCellView.self, ProfilePhoneCell.self])
        self.title = "Личная информация"
    }
    
    deinit {
        self.viewModel.views.removeLast()
    }
    
    private func showPhotoAlert() {
        let alert = UIAlertController(title: "Добавить фото", message: "Выберите способ", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { [unowned self] _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Библиотека", style: .default, handler: { [unowned self] _ in
            self.openPhotoLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let myPickerController = UIImagePickerController()
            myPickerController.modalPresentationStyle = .overFullScreen
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            myPickerController.cameraDevice = .front
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    private func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.modalPresentationStyle = .overFullScreen
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func savePressed() {
        self.viewModel.updateProfile(self.templateProfile)
    }
    
}

//MARK: - Photo

extension ProfileInformationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.templateProfile.photo = image
        } else {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
        self.tableView.reloadData()
    }
    
}

extension ProfileInformationController: ProfileView {
    
    func openUpdateSuccessAlert() {
        self.openInfoAlert(title: "Данные успешно изменены",
                           descr: "Новые данные уже отображаются в Вашем профиле")
    }
    
    func error(message: String) {
        self.openErrorAlert(message: message)
    }
    
    func setupLoading(_ isLoading: Bool) {
        self.actionButton.setupLoading(isLoading)
    }
    
    func updateCustomer(_ customer: CustomerModel) {
        self.tableView.reloadData()
    }
    
}

extension ProfileInformationController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.showPhotoAlert()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileImageCellView.self), for: indexPath) as? ProfileImageCellView {
                cell.setupIcon(icon: self.templateProfile.photoString, iconData: self.templateProfile.photo)
                return cell
            }
        case 5:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfilePhoneCell.self), for: indexPath) as? ProfilePhoneCell {
                cell.setupPhone(self.viewModel.profile.phone ?? "")
                cell.changeAction = { [unowned self] in
                    AuthController.openAuthController(viewController: self, type: .change)
                }
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FieldCellView.self), for: indexPath) as? FieldCellView {
                let model = self.registerCellModels[indexPath.row - 1]
                cell.setupModel(model)
                cell.action = { text in
                    switch indexPath.row {
                    case 1:
                        self.templateProfile.name = text
                    case 2:
                        self.templateProfile.lastName = text
                    case 3:
                        self.templateProfile.birthday = text
                    case 4:
                        self.templateProfile.email = text
                    default:
                        return
                    }
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
}
