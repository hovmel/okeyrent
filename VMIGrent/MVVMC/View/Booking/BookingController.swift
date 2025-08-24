//
//  BookingController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.07.2022.
//

import Foundation
import UIKit

enum BookingCellType {
    case object(ObjectModel)
    case price(PriceModel, [PriceModel])
    case dates
    case rules(Int, Int)
    case terms([FeatureModel])
    case open(String)
}

class BookingController: UIViewController {
    
    class func openBookingController(viewController: UIViewController, object: ObjectModel, filterModel: FilterModel) {
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        var controllers: [UIViewController] = viewController.navigationController?.viewControllers ?? [viewController]
        let bookingController = storyboard.instantiateViewController(withIdentifier: "BookingController") as! BookingController
        bookingController.viewModel = BookingViewModel(view: bookingController, object: object, filterModel: filterModel)
        controllers.append(bookingController)
        viewController.navigationController?.setViewControllers(controllers, animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var botView: UIView!
    @IBOutlet weak var bookButton: VmigButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var priceView: PriceView!
    @IBOutlet weak var datesLabel: UILabel!
    
    var viewModel: BookingViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    var sections: [BookingCellType] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.sections = [.object(self.viewModel.object)]
        self.datesLabel.text = self.viewModel.filterModel.dateStr
        self.priceView.setupPrice(self.viewModel.object.priceDay ?? 0)
        self.bookButton.isEnabled = true
        self.bookButton.action = { [unowned self] in
            self.viewModel.createBooking()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.calculateBooking()
    }
    
    private func setupUI() {
        self.title = "Бронирование"
        self.commonTableViewSetup(tableView: self.tableView, cells: [ObjectShortCellView.self,
                                                                     ObjectDescriptionCellView.self,
                                                                     BookingTimeCellView.self,
                                                                     BookingPriceCellView.self,
                                                                     ObjectFeaturesCellView.self])
        self.tableView.separatorStyle = .singleLine
        self.tableView.tableHeaderView = UIView()
        self.botView.layer.cornerRadius = 20
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        self.botView.backgroundColor = Colors.f2f2f2
        self.botView.makeShadow()
        self.commonSetup()
    }
    
}

extension BookingController: BookingView {
    
    func error(message: String) {
        self.openErrorAlert(message: message)
    }
    
    func calculateError(message: String) {
        self.openErrorAlert(message: message) { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
    }
    func openPayment(url: URL) {
        WebController.openWebController(viewController: self, url: url, type: .payment(self.viewModel.booking.id!))
    }
    
    func setupInfo(object: ObjectModel, booking: BookingModel) {
        self.sections = [.object(object),
                         .dates,
                         .price(PriceModel(title: "Итого", price: booking.priceTotal ?? 0),
                                [booking.basePrice == nil ? nil : PriceModel(title: "Размещение", price: booking.basePrice!),
                                 booking.penalty == nil ? nil : PriceModel(title: "Наценка", price: booking.penalty!),
                                 booking.priceTotalWithoutDiscount == nil ? nil : PriceModel(title: "Итого без скидки", price: booking.priceTotalWithoutDiscount!),
                                 booking.discount == nil ? nil : PriceModel(title: "Скидка", price: booking.discount!),
                                ].compactMap({$0})),
                         .open(object.checkInType?.description ?? "")]
        if let features = object.features, !features.isEmpty {
            self.sections.append(.terms(object.features ?? []))
        }
        if let cancelHours = booking.cancelHours, let cancelPercent = booking.cancelPercent {
            self.sections.append(.rules(cancelHours, cancelPercent))
        }
        self.priceView.setupPrice(object.priceDay ?? 0)
        self.datesLabel.text = self.viewModel.filterModel.dateStr
    }
    
    func setupLoading(_ isLoading: Bool) {
        self.bookButton.setupLoading(isLoading)
    }
    
    func setupCalculateLoading(_ isLoading: Bool) {
        isLoading ? self.loader.startAnimating() : self.loader.stopAnimating()
    }
}

extension BookingController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.sections[indexPath.row] {
        case .object(let object):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ObjectShortCellView.self), for: indexPath) as? ObjectShortCellView {
                cell.setupModel(object)
                return cell
            }
        case .dates:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BookingTimeCellView.self), for: indexPath) as? BookingTimeCellView {
                cell.setupModel(BookingTimeCellModel(dates: self.viewModel.filterModel.dateStr,
                                                     startTime: self.viewModel.filterModel.startTime!,
                                                     endTime: self.viewModel.filterModel.endTime!,
                                                     nights: String.makeNights(Calendar.current.numberOfDaysBetween(self.viewModel.filterModel.startDate!,and: self.viewModel.filterModel.endDate!))))
                cell.dateAction = {
                    self.openCalendar(startDate: self.viewModel.filterModel.startDate!,
                                      endDate: self.viewModel.filterModel.endDate!) { [unowned self] minDate, maxDate in
                        guard let minDate = minDate, let maxDate = maxDate else {return}
                        self.viewModel.filterModel.startDate = minDate
                        self.viewModel.filterModel.endDate = maxDate
                        self.viewModel.calculateBooking()
                    }
                }
                cell.endAction = { [unowned self] in
                    guard let type = self.viewModel.booking.object?.checkInType?.id, type != .owner else {return}
                    self.openTileController(title: "Время выезда",
                                            value: self.viewModel.filterModel.endTime,
                                            minDate: nil,
                                            maxDate: DateFormatter.hoursAndMnutes.date(from: self.viewModel.object.checkOutTimeEnd!) ?? Date()) { [unowned self] endTime in
                        self.viewModel.filterModel.endTime = endTime
                        self.viewModel.filterModel.startTime = endTime
                        self.tableView.reloadData()
                    }
                }
                cell.startAction = {
                    guard let type = self.viewModel.booking.object?.checkInType?.id, type != .owner else {return}
                    self.openTileController(title: "Время заезда",
                                            value: self.viewModel.filterModel.startTime,
                                            minDate: DateFormatter.hoursAndMnutes.date(from: self.viewModel.object.checkInTimeStart!) ?? Date(),
                                            maxDate: DateFormatter.hoursAndMnutes.date(from: self.viewModel.object.checkInTimeEnd!) ?? Date()) { [unowned self] startTime in
                        self.viewModel.filterModel.startTime = startTime
                        self.viewModel.filterModel.endTime = startTime
                        self.tableView.reloadData()
                    }
                }
                return cell
            }
        case .terms(let features):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ObjectFeaturesCellView.self), for: indexPath) as? ObjectFeaturesCellView {
                cell.setModels(features)
                return cell
            }
        case .price(let total, let other):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BookingPriceCellView.self), for: indexPath) as? BookingPriceCellView {
                cell.setupModels(total: total, models: other)
                return cell
            }
        case .rules(let hours, let percent):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ObjectDescriptionCellView.self), for: indexPath) as? ObjectDescriptionCellView {
                let title = "Условия отмены бронирования"
                let descr = "Бесплатная отмена бронирования за \(String.makeHours(hours)). После будет списан невозвратный платеж в размере \(percent)%."
                cell.setupModel(title: title,
                                descr: descr,
                                isButton: true)
                cell.action = { [unowned self] in
                    self.openInfoAlert(title: title,
                                       descr: descr)
                }
                return cell
            }
        case .open(let descr):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ObjectDescriptionCellView.self), for: indexPath) as? ObjectDescriptionCellView {
                cell.setupModel(descr: descr)
                return cell
            }
        }
        return UITableViewCell()
    }
}
