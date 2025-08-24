//
//  InfoController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 07.07.2022.
//

import Foundation
import UIKit

enum InfoControllerType {
    case time
    case payment(Int)
    case document
    case errorPayment
    case endBooking
    case cancelBooking
    case documentWait
    
    var title: String {
        switch self {
        case .time:
            return "Почти готово!"
        case .payment:
            return "Оплата прошла успешно"
        case .document:
            return "С вашими документами всё в порядке"
        case .errorPayment:
            return "Оплата не удалась"
        case .endBooking:
            return "Бронирование успешно завершено"
        case .cancelBooking:
            return "Бронирование успешно отменено"
        case .documentWait:
            return "Проверка документов"
        }
    }
    
    var image: UIImage {
        switch self {
        case .time:
            return UIImage(named: "info_time")!
        case .payment, .cancelBooking, .endBooking:
            return UIImage(named: "info_success")!
        case .document:
            return UIImage(named: "info_document")!
        case .documentWait:
            return UIImage(named: "info_docs_wait")!
        case .errorPayment:
            return UIImage(named: "info_error_pay")!
        }
    }
    
    var descr: String {
        switch self {
        case .time:
            return "Документы на проверке.\nВ ближайшее время мы проверим фотографии и  сообщим результат.\nВы можете прдолжить с того места, где остановились."
        case .payment:
            return "Запрос на бронирование отправлен владельцу.\nМы пришлём вам уведомление, когда владелец\nпримет решение"
        case .endBooking, .documentWait:
            return ""
        case .document:
            return "Ваши документы прошли модерацию. Ваш профиль подтверждён. Теперь вы можете оформлять бронирования без указания дополнительной информации."
        case .cancelBooking:
            return "Средства вернутся на ваш счет в течение трех рабочих дней. Ждём вас снова"
        case .errorPayment:
            return "При обработке платежа произошла ошибка"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .time, .endBooking, .cancelBooking:
            return "Найти жильё"
        case .payment:
            return "К бронированию"
        case .document:
            return "Искать жильё"
        case .errorPayment:
            return "Повторить оплату"
        case .documentWait:
            return "Понятно"
        }
    }
    
    var buttonColor: UIColor {
        switch self {
        case .time, .payment, .errorPayment, .cancelBooking, .endBooking, .documentWait:
            return Colors.mainBlack
        case .document:
            return Colors.main
        }
    }
}

class InfoController: UIViewController {
    
    class func openInfoController(viewController: UIViewController, type: InfoControllerType) {
        let storyboard = UIStoryboard(name: "Info", bundle: nil)
        var controllers: [UIViewController] = viewController.navigationController?.viewControllers ?? [viewController]
        let infoController = storyboard.instantiateInitialViewController() as! InfoController
        infoController.type = type
        controllers.append(infoController)
        viewController.navigationController?.setViewControllers(controllers, animated: true)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var type: InfoControllerType = .time
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        self.commonSetup()
        switch self.type {
        case .payment, .errorPayment, .endBooking, .cancelBooking:
            self.navigationItem.setHidesBackButton(true, animated: false)
        default:
            break
        }
        self.imageView.image = self.type.image
        self.titleLabel.text = self.type.title
        self.descrLabel.text = self.type.descr
        self.descrLabel.isHidden = self.type.descr == ""
        self.actionButton.setTitle(self.type.buttonTitle, for: .normal)
        self.actionButton.backgroundColor = self.type.buttonColor
    }
    
    @IBAction func actionPressed() {
        switch self.type {
        case .time, .document, .endBooking, .cancelBooking:
            self.navigationController?.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: .openMap, object: nil)
            NotificationCenter.default.post(name: .openMenu, object: nil)
        case .payment(let id):
            BookingDetailController.openBookingDetailController(viewController: self, id: id)
        case .errorPayment:
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        case .documentWait:
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
