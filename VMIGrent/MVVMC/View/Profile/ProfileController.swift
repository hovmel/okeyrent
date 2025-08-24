//
//  ProfileController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 06.06.2022.
//

import Foundation
import UIKit

enum ProfileMenu {
    case profile
    case info
    case docs(String?, DocumentState?)
    case support
    case about
    case agreement
    case politic
    case auth(Bool)
    case delete
    case version
    
    var title: String {
        switch self {
        case .profile:
            return ""
        case .info:
            return "Личная информация"
        case .docs:
            return "Документы"
        case .support:
            return "Служба поддержки"
        case .about:
            return "О приложении"
        case .agreement:
            return "Пользовательское соглашение"
        case .politic:
            return "Политика обработки персональных данных"
        case .auth(let isAuth):
            return isAuth ? "Выйти" : "Авторизоваться"
        case .delete:
            return "Удалить аккаунт"
        case .version:
            return "Версия: \(Bundle.main.releaseVersionNumber) (\(Bundle.main.buildVersionNumber))"
        }
    }
}

class ProfileController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    var viewModel: ProfileViewModel!
    
    var profileMenus: [ProfileMenu] {
        if AuthManager.shared.authComplete() {
            return [.profile,
                    .info,
                    .docs(self.viewModel.profile.documentState?.title, self.viewModel.profile.documentState?.id),
                    .support,
                    .about,
                    .auth(true),
                    .delete]
        } else {
            return [.support, .about, .auth(false)]
        }
    }
    
    var profileCellModel: ProfileCellModel {
        return ProfileCellModel(photo: self.viewModel.profile.picture?.original ?? "",
                                name: self.viewModel.profile.name ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        NotificationCenter.default.post(name: .openMenu, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        NotificationCenter.default.post(name: .closeMenu, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ProfileViewModel(view: self)
        if AuthManager.shared.authComplete() {
            self.viewModel.getProfile()
        }
        self.setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateProfile), name: .updateProfile, object: nil)
    }
    
    @objc func updateProfile() {
        self.viewModel.getProfile()
    }
    
    private func setupUI() {
        self.commonSetup()
        self.commonTableViewSetup(tableView: self.tableView,
                                  cells: [ProfileCellView.self,
                                          ProfileMenuCellView.self,
                                          ButtonCellView.self])
        self.tableView.separatorStyle = .singleLine
    
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.viewModel.getProfile()
    }
    
}

extension ProfileController: ProfileView {
    func logout() {
        self.openLoadController()
    }
    
    func error(message: String) {
        
    }
    
    func setupLoading(_ isLoading: Bool) {
        self.refreshControl.setLoading(isLoading)
    }
    
    func updateCustomer(_ customer: CustomerModel) {
        self.tableView.reloadData()
    }
}

extension ProfileController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.profileMenus[indexPath.row]
        switch model {
        case .delete:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ButtonCellView.self), for: indexPath) as? ButtonCellView {
                cell.setupButton(title: model.title, image: nil)
                cell.action = { [unowned self] in
                    self.openInfoAlert(title: "Удаление аккаунта",
                                       descr: "Подтвердите удаление аккаунта, все данные будут утеряны",
                                       leftAction: {
                        self.viewModel.delete()
                    },
                                       leftTitle: "Удалить",
                                       rightTitle: "Отмена")
                }
                return cell
            }
        case .auth(let isAuth):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ButtonCellView.self), for: indexPath) as? ButtonCellView {
                cell.setupButton(title: model.title, image: isAuth ? UIImage(named: "logout")! : nil)
                cell.action = { [unowned self] in
                    if isAuth {
                        self.openInfoAlert(title: "Выход",
                                           descr: "Вы уверены, что хотите выйти?",
                                           leftAction: {
                            self.viewModel.logout()
                        },
                                           leftTitle: "Выйти",
                                           rightTitle: "Отмена")
                        
                    } else {
                        self.openEnterController()
                    }
                }
                return cell
            }
        case .profile:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileCellView.self), for: indexPath) as? ProfileCellView {
                cell.setupModel(self.profileCellModel)
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileMenuCellView.self), for: indexPath) as? ProfileMenuCellView {
                switch model {
                case .docs(let descr, let state):
                    cell.setupModel(ProfileMenuCellModel(title: model.title,
                                                         descr: descr,
                                                         color: state?.color,
                                                         textColor: state?.textColor))
                default:
                    cell.setupModel(ProfileMenuCellModel(title: model.title))
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profileMenus.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.profileMenus[indexPath.row]
        switch model {
        case .profile, .info:
            ProfileInformationController.openProfileInformationController(viewController: self, viewModel: self.viewModel)
        case .docs:
//            switch self.viewModel.profile.documentStateId {
//            case .accepted:
//                InfoController.openInfoController(viewController: self, type: .document)
//            case .moderation:
//                InfoController.openInfoController(viewController: self, type: .documentWait)
//            default:
                DocumentsController.openDocumentsController(viewController: self, viewModel: self.viewModel, isStep: false)
//            }
        case .support:
            SupportController.openSupportController(viewController: self,
                                                    phone: DefinitionManager.shared.contactPhone,
                                                    email: DefinitionManager.shared.contactEmail)
        case .about:
            AboutController.openAboutController(viewController: self,
                                                agreement: DefinitionManager.shared.userAgreement,
                                                politic: DefinitionManager.shared.privacyPolicy)
        default:
            return
        }
    }
    
}
