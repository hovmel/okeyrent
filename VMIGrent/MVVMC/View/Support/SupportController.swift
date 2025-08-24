//
//  SupportController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 26.06.2022.
//

import Foundation
import UIKit
import MessageUI

class SupportController: UIViewController, MFMailComposeViewControllerDelegate {
    
    class func openSupportController(viewController: UIViewController, phone: String, email: String) {
        let storyboard = UIStoryboard(name: "Support", bundle: nil)
        var controllers: [UIViewController] = viewController.navigationController?.viewControllers ?? [viewController]
        let supportController = storyboard.instantiateInitialViewController() as! SupportController
        supportController.email = email
        supportController.phone = phone
        controllers.append(supportController)
        viewController.navigationController?.setViewControllers(controllers, animated: true)
    }
    
    var phone: String = ""
    var email: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonSetup()
        self.commonTableViewSetup(tableView: self.tableView, cells: [ProfileActionCell.self, UITableViewCell.self])
        self.tableView.separatorStyle = .singleLine
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([self.email])
            mail.setMessageBody("<p>Добрый день!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            self.openInfoAlert(title: "Не выполнен вход в почту",
                               descr: "На вашем устройстве нет подключенной почты, скопируйте адрес и отправьте нам письмо любым другим способом",
                               rightAction: { [unowned self] in
                self.vibrate()
                UIPasteboard.general.string = self.email
            },
                               rightTitle: "Скопировать почту")
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}

extension SupportController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            if let url = URL(string: "tel://\(self.phone)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        case 2:
            self.sendEmail()
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileActionCell.self), for: indexPath) as? ProfileActionCell {
            switch indexPath.row {
            case 1:
                cell.titleLabel.text = "Телефон горячей линии"
                cell.actionLabel.text = self.phone
            case 2:
                cell.titleLabel.text = "Электронная почта"
                cell.actionLabel.text = self.email
            default:
                let tableCell = UITableViewCell()
                tableCell.backgroundColor = Colors.f2f2f2
                tableCell.selectionStyle = .none
                return tableCell
            }
            return cell
        }
        return UITableViewCell()
    }
    
}
