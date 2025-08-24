//
//  BookingEndController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 13.07.2022.
//

import Foundation
import UIKit

enum BookingEndControllerCellType {
    case rules
    case price(PriceModel, [PriceModel])
}

enum BookingEndControllerType {
    case cancel
    case end
    
    var title: String {
        switch self {
        case .cancel:
            return "Отмена\nбронирования"
        case .end:
            return "Завершение\nбронирования"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .cancel:
            return "Подтвердить отмену"
        case .end:
            return "Подтвердить завершение"
        }
    }
}

class BookingEndController: UIViewController {
    
    class func openBookingEndController(viewController: UIViewController, booking: BookingModel, type: BookingEndControllerType) {
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        var controllers: [UIViewController] = viewController.navigationController?.viewControllers ?? [viewController]
        let bookingEndController = storyboard.instantiateViewController(withIdentifier: "BookingEndController") as! BookingEndController
        bookingEndController.type = type
        bookingEndController.viewModel = BookingEndViewModel(view: bookingEndController, booking: booking)
        controllers.append(bookingEndController)
        viewController.navigationController?.setViewControllers(controllers, animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: CommonButton!
    
    var viewModel: BookingEndViewModel!
    
    var sections: [BookingEndControllerCellType] {
        return [.rules,
                .price(PriceModel(title: "Итого к возврату", price: self.viewModel.booking.cancelPriceTotal),
                              [(self.viewModel.booking.priceTotal != nil ? PriceModel(title: "Размещение", price: self.viewModel.booking.priceTotal!) : nil),
                               (self.viewModel.booking.cancelPrice != nil ? PriceModel(title: "Удержано за отмену", price: self.viewModel.booking.cancelPrice!) : nil)].compact)]
    }
    
    var type: BookingEndControllerType = .cancel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupUI() {
        self.commonSetup()
        self.commonTableViewSetup(tableView: self.tableView, cells: [BookingPriceCellView.self,
                                                                     ObjectDescriptionCellView.self])
        self.titleLabel.text = self.type.title
        self.actionButton.setTitle(self.type.buttonTitle, for: .normal)
        self.tableView.separatorStyle = .singleLine
    }
    
    @IBAction func actionPressed() {
        switch self.type {
        case .cancel:
            self.viewModel.cancelBooking()
        case .end:
            self.viewModel.endBooking()
        }
    }
    
}

extension BookingEndController: BookingEndView {
    
    func error(_ message: String) {
        self.openErrorAlert(message: message)
    }
    
    func setupLoading(_ isLoading: Bool) {
        self.actionButton.setupLoading(isLoading)
    }
    
    func openSuccess() {
        switch self.type {
        case .end:
            InfoController.openInfoController(viewController: self, type: .endBooking)
        case .cancel:
            InfoController.openInfoController(viewController: self, type: .cancelBooking)
        }
    }
    
    func openAlert(message: String) {
        self.openInfoAlert(title: message)
    }
    
}

extension BookingEndController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.row]
        switch section {
        case .rules:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ObjectDescriptionCellView.self), for: indexPath) as? ObjectDescriptionCellView {
                cell.setupModel(title: "Условия отмены",
                                descr: self.viewModel.booking.cancelRules,
                                isButton: false)
                return cell
            }
        case .price(let total, let prices):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BookingPriceCellView.self), for: indexPath) as? BookingPriceCellView {
                cell.setupModels(total: total, models: prices, title: "Расчёт возврата")
                return cell
            }
        }
        return UITableViewCell()
    }
    
}
