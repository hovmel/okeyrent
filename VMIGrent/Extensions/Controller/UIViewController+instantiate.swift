//
//  UIViewController+instantiate.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 01.06.2022.
//

import Foundation
import UIKit
import HorizonCalendar
import AudioToolbox

extension UIViewController {
    
    func vibrate() {
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.prepare()
        feedbackGenerator.selectionChanged()
//        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    static func instantiate<T>(sbName: String) -> T {
        let storyboard = UIStoryboard(name: sbName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
        return controller
    }
    
    func commonSetup() {
        self.view.backgroundColor = Colors.f2f2f2
        let yourBackImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.mainBlack,
                                                                        NSAttributedString.Key.font: Fonts.medium(size: 18)]
    }
    
    func commonTableViewSetup(tableView: UITableView, cells: [Any.Type]) {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        for cell in cells {
            tableView.register(UINib(nibName: String(describing: cell.self), bundle: nil),
                               forCellReuseIdentifier: String(describing: cell.self))
        }
    }
    
}

extension UIViewController {
    func openMain() {
        let sb = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = sb
    }
    
    @objc func openAgreement(gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel else {return}
        let text = "Продолжая, вы принимаете условия пользовательского соглашения и политики конфиденциальности"
        let agreement = "пользовательского соглашения"
        let politic = "политики конфиденциальности"
        let rangeAgreement = (text as NSString).range(of: agreement)
        let rangePolitic = (text as NSString).range(of: politic)
        if gesture.didTapAttributedTextInLabel(label: label, inRange: rangeAgreement) {
            if let url = URL(string: DefinitionManager.shared.userAgreement) {
                WebController.openWebController(viewController: self, url: url, type: .simple)
            }
        } else if gesture.didTapAttributedTextInLabel(label: label, inRange: rangePolitic) {
            if let url = URL(string: DefinitionManager.shared.privacyPolicy) {
                WebController.openWebController(viewController: self, url: url, type: .simple)
            }
        }
    }
    
    func presentAuthAlert() {
//        let alert = UIAlertController(title: "Вы не авторизованы", message: "Для данного действия необходимо авторизация", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
//        alert.addAction(UIAlertAction(title: "Авторизоваться", style: .default, handler: { _ in
//            self.openEnterController()
//        }))
//        self.present(alert, animated: true)
        self.openInfoAlert(title: "Вы не авторизованы",
                           descr: "Для данного действия необходимо авторизация",
                           leftAction: { [unowned self] in
            self.openEnterController()
        },
                           leftTitle: "Авторизоваться",
                           rightTitle: "Отмена")
    }
    
    func openErrorAlert(message: String, action: (() -> ())? = nil) {
        self.openInfoAlert(title: "Ошибка", descr: message, rightAction: action)
    }
    
    func openInfoAlert(title: String, descr: String? = nil, leftAction: (() -> ())? = nil, rightAction: (() -> ())? = nil, leftTitle: String? = nil, rightTitle: String? = nil) {
        let timeController = VmigAlertController()
        timeController.modalPresentationStyle = .overFullScreen
        let model = VmigAlertModel(title: title, descr: descr, leftAction: leftAction, rightAction: rightAction, leftTitle: leftTitle, rightTitle: rightTitle)
        timeController.model = model
        present(timeController, animated: false, completion: nil)
    }
}


extension UIViewController {
    
    func openImageZoomController(images: [String], index: Int) {
        let imageZoomController = ImageZoomController()
        imageZoomController.modalPresentationStyle = .overFullScreen
        imageZoomController.images = images
        imageZoomController.index = index
        present(imageZoomController, animated: true, completion: nil)
    }
    
    func openFeedbackController(vmigPhone: String?, ownerPhone: String?) {
        let feedbackController = FeedbackController()
        feedbackController.modalPresentationStyle = .overFullScreen
        feedbackController.ownerPhone = ownerPhone
        feedbackController.vmigrentPhone = vmigPhone
        present(feedbackController, animated: false, completion: nil)
    }
    
    func openRegionsController(action: ((CityModel) -> ())?) {
        let regionController = RegionsController()
        regionController.action = action
        present(regionController, animated: true, completion: nil)
    }
    
    func openTileController(title: String, value: Date?, minDate: Date?, maxDate: Date?, action: ((Date) -> ())?) {
        let timeController = TimeController()
        timeController.modalPresentationStyle = .overFullScreen
        timeController.action = action
        timeController.value = value
//        timeController.maxDate = maxDate
//        timeController.minDate = minDate
        timeController.loadViewIfNeeded()
        timeController.titleLabel.text = title
        present(timeController, animated: false, completion: nil)
    }
    
    func openEnterController() {
        EnterController.openEnterController(viewController: self)
//        let sb = UIStoryboard(name: "Enter", bundle: nil)
//        let controller = sb.instantiateInitialViewController()
//        UIApplication.shared.windows.first?.rootViewController = controller
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func openLoadController() {
        let sb = UIStoryboard(name: "Load", bundle: nil)
        let controller = sb.instantiateInitialViewController()
        UIApplication.shared.windows.first?.rootViewController = controller
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func openCalendar(isClearButton: Bool = true, startDate: Date?, endDate: Date?, action: @escaping (Date?, Date?) -> ()) {
        let calendarController = CalendarController()
//        moneyController.modalPresentationStyle = .
        calendarController.loadViewIfNeeded()
        if let startDate = startDate {
            calendarController.startDay = Day(month: Month(era: startDate.get(.era),
                                                           year: startDate.get(.year),
                                                           month: startDate.get(.month),
                                                           isInGregorianCalendar: true),
                                              day: startDate.get(.day))
        }
        if let endDate = endDate {
            calendarController.endDay = Day(month: Month(era: endDate.get(.era),
                                                         year: endDate.get(.year),
                                                         month: endDate.get(.month),
                                                         isInGregorianCalendar: true),
                                             day: endDate.get(.day))
        }
        calendarController.action = action
        calendarController.clearButton.isHidden = !isClearButton
        present(calendarController, animated: true, completion: nil)
    }
    
    func openFilter(filterModel: FilterModel, action: @escaping (FilterModel) -> ()) {
        let filterController = FilterController()
//        moneyController.modalPresentationStyle = .
//        moneyController.action = action
        if let copy = filterModel.copy() as? FilterModel {
            filterController.filterModel = copy
        }
        filterController.action = action
        filterController.loadViewIfNeeded()
        present(filterController, animated: true, completion: nil)
    }
}
