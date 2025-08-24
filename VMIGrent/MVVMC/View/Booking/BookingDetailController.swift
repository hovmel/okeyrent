//
//  BookingDetailController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 11.07.2022.
//

import Foundation
import UIKit
import CoreLocation

enum BookingDetailControllerSection {
    case object(ObjectModel)
    case information(BookingInformationCellViewModel)
    case detail(BookingDetailCellModel)
    case intercom(String)
    case rules(BookingRulesCellModel)
}

enum LockVmigState {
    case open
    case close
    case loading
    
    var title: String {
        switch self {
        case .open:
            return "Открыть замок"
        case .close:
            return "Закрыть замок"
        case .loading:
            return "Идет синхронизация..."
        }
    }
    
    var image: String? {
        switch self {
        case .open:
            return "unlock"
        case .close:
            return "lock"
        case .loading:
            return nil
        }
    }
}

class BookingDetailController: UIViewController {
    
    class func openBookingDetailController(viewController: UIViewController, id: Int) {
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        var controllers: [UIViewController] = [viewController.navigationController?.viewControllers.first ?? viewController]
        let bookingDetailController = storyboard.instantiateViewController(withIdentifier: "BookingDetailController") as! BookingDetailController
        bookingDetailController.viewModel = BookingDetailViewModel(view: bookingDetailController, id: id)
        controllers.append(bookingDetailController)
        viewController.navigationController?.setViewControllers(controllers, animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoriteButton: FavoriteButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var galleryView: GalleryView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var botView: UIView!
    @IBOutlet weak var closeButton: VmigButton!
    @IBOutlet weak var openButton: VmigButton!
    
    var viewModel: BookingDetailViewModel!
    
    var isInProgress: Bool = false
    
    var sections: [BookingDetailControllerSection] = []
    
    deinit {
        NotificationCenter.default.post(name: .openMenu, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.getBooking()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.galleryView.roundedCorners(top: false)
    }
    
    private func setupUI() {
        self.navigationController?.navigationBar.barStyle = .black
        self.title = ""
        self.favoriteButton.makeShadow()
        self.backButton.makeShadow()
        self.botView.backgroundColor = Colors.f2f2f2
        self.commonSetup()
        self.tableView.separatorStyle = .singleLine
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        self.commonTableViewSetup(tableView: self.tableView, cells: [ObjectSummaryCellView.self,
                                                                     BookingInformationCellView.self,
                                                                     BookingDetailCellView.self,
                                                                     BookingRulesCellView.self,
                                                                     ObjectDescriptionCellView.self])
        self.botView.layer.cornerRadius = 20
        self.botView.makeCenterShadow()
        self.botView.backgroundColor = Colors.f2f2f2
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = Colors.f2f2f2
        self.view.isUserInteractionEnabled = true
        self.closeButton.isEnabled = true
        self.openButton.isEnabled = true
        self.closeButton.title = LockVmigState.close.title
        self.openButton.title = LockVmigState.open.title
        self.closeButton.image = nil
        self.openButton.image = nil
        self.botView.alpha = 0
        self.closeButton.action = { [unowned self] in
            if !self.isInProgress {
                self.perform(#selector(self.clearLock), with: nil, afterDelay: 8.0)
                self.isInProgress = true
                self.viewModel.closeLock()
            }
        }
        self.openButton.action = { [unowned self] in
            if !self.isInProgress {
                self.perform(#selector(self.clearLock), with: nil, afterDelay: 8.0)
                self.isInProgress = true
                self.viewModel.openLock()
            }
        }
    }
    
    @objc func clearLock() {
        self.closeButton.setupLoading(false)
        self.openButton.setupLoading(false)
        self.isInProgress = false
        self.viewModel.getLock()
    }
    
    @IBAction func favoritePressed() {
        self.viewModel.favoriteEvent()
    }
    
    @IBAction func backPressed() {
        NotificationCenter.default.post(name: .openMenu, object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func openStatusLockView(type: LockStatusViewType) {
        if !self.view.subviews.contains(where: {$0.tag == 100}) {
            let statusView = LockStatusView.instanceFromNib(type: type)
            statusView.frame = UIScreen.main.bounds
            statusView.tag = 100
            self.view.addSubview(statusView)
        }
    }
    
    func setupVmigButtonState(_ state: LockVmigState) {
        switch state {
        case .loading:
            self.closeButton.isHidden = true
        default:
            self.closeButton.isHidden = false
        }
        self.openButton.title = state.title
//        self.openButton.image = state.image
    }
    
}

extension BookingDetailController: LockManagerDelegate {
    func changeLockStatus(_ status: LockState) {
        self.openButton.setupLoading(false)
        self.closeButton.setupLoading(false)
    }
    
    func didFinishAction(_ status: LockState) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.isInProgress = false
        self.openButton.setupLoading(false)
        self.closeButton.setupLoading(false)
        switch status {
        case .locked:
            self.openStatusLockView(type: .closed)
        case .unLock:
            self.openStatusLockView(type: .opened)
        default:
            break
        }
    }
    
    func didDisconnect() {
        self.viewModel.getLock()
    }
    
    func didConnect() {
        self.setupVmigButtonState(.open)
    }
    
    func didConnecting() {
        self.setupVmigButtonState(.loading)
    }
}

extension BookingDetailController: BookingDetailView {
    func closeLock() {
        LockManager.shared.closeLock()
    }
    
    func openLock() {
        LockManager.shared.openLock()
    }
    
    func hideLock(_ isHide: Bool) {
        self.botView.alpha = isHide ? 0 : 1
    }
    
    func setupLoadingLock(_ isLoading: Bool) {
        self.openButton.setupLoading(isLoading)
    }
    
    func setupLoadingUnlock(_ isLoading: Bool) {
        self.closeButton.setupLoading(isLoading)
    }
    
    func connectLock(_ lockModel: LockConfigModel) {
        LockManager.shared.delegate = self
        LockManager.shared.lock = lockModel
    }
    
    func endSuccess() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func error(_ message: String) {
        self.openErrorAlert(message: message)
    }
    
    func setupFavoriteLoading(_ isLoading: Bool) {
        self.favoriteButton.setupLoading(isLoading)
    }
    
    func setupLoading(_ isLoading: Bool) {
        isLoading ? self.loader.startAnimating() : self.loader.stopAnimating()
    }
    
    func setupBooking(_ booking: BookingModel) {
        guard booking.object != nil else {return}
        self.favoriteButton.isSelected = booking.object?.inFavorite ?? false
        var sections: [BookingDetailControllerSection] = [.object(booking.object!),
                                                          .information(booking.infoCellView),
                                                          .detail(booking.detailCellView)]
        if let intercom = booking.intercomString {
            sections.append(.intercom(intercom))
        }
        sections.append(.rules(booking.bookingRulesCellModel))
        self.sections = sections
        self.galleryView.images = booking.object?.pictures?.map({ImageCellViewModel(image: $0.picture?.original)}) ?? []
        self.tableView.reloadData()
    }
    
}

extension BookingDetailController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.sections[indexPath.row] {
        case .object(let object):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ObjectSummaryCellView.self), for: indexPath) as? ObjectSummaryCellView {
                cell.setupModel(object)
                cell.isShort = true
                cell.mapAction = { [unowned self] in
                    MapController.openMapController(viewController: self,
                                                    city: object.city!,
                                                    object: object)
                }
                return cell
            }
        case .information(let info):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BookingInformationCellView.self), for: indexPath) as? BookingInformationCellView {
                cell.setupModel(info)
                return cell
            }
        case .detail(let detail):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BookingDetailCellView.self), for: indexPath) as? BookingDetailCellView {
                cell.setupModel(detail)
                cell.downloadAction = { [unowned self] in

                }
                cell.copyAction = { [unowned self] in
                    self.vibrate()
                    UIPasteboard.general.string = detail.number
                }
                return cell
            }
        case .rules(let rules):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BookingRulesCellView.self), for: indexPath) as? BookingRulesCellView {
                cell.setupModel(rules)
                cell.moreAction = { [unowned self] in
                    self.openInfoAlert(title: "Условия отмены бронирования",
                                       descr: rules.descr)
                }
                cell.cancelAction = { [unowned self] in
                    BookingEndController.openBookingEndController(viewController: self, booking: self.viewModel.booking!, type: .cancel)
                }
                cell.endAction = { [unowned self] in
//                    BookingEndController.openBookingEndController(viewController: self, booking: self.viewModel.booking!, type: .end)
                    self.openInfoAlert(title: "Завершение бронирования",
                                       descr: "Вы уверены, что хотите завершить бронирование досрочно?",
                                       leftAction: { [unowned self] in
                        self.viewModel.endBooking()
                    },
                                       rightAction: nil,
                                       leftTitle: "Завершить",
                                       rightTitle: "Отмена")
                }
                cell.callAction = { [unowned self] in
                    self.openFeedbackController(vmigPhone: DefinitionManager.shared.contactPhone,
                                                ownerPhone: self.viewModel.booking?.object?.owner?.phone)
                }
                cell.reviewAction = { [unowned self] in
                    if let object = self.viewModel.booking?.object {
                        ReviewController.openReviewController(viewController: self, object: object)
                    }
                }
                cell.detailAction = { [unowned self] in

                }
                return cell
            }
        case .intercom(let intercom):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ObjectDescriptionCellView.self), for: indexPath) as? ObjectDescriptionCellView {
                cell.setupModel(title: "Детали заселения", descr: intercom)
                return cell
            }
        }
        return UITableViewCell()
    }
    
}
