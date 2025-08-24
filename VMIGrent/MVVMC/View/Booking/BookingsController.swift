//
//  BookingsController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 29.06.2022.
//

import Foundation
import UIKit

class BookingsController: UIViewController {
    
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var emptyView: EmptyView!
    
    var favoriteLoadingID: Int?
    
    var viewModel: BookingListViewModel!
    
    var sections: [BookingListSectionModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = BookingListViewModel(view: self)
        self.setupUI()
        if AuthManager.shared.authComplete() {
            self.viewModel.getBookings()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.getBookings), name: .openedBookings, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: .openMenu, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: .closeMenu, object: nil)
    }
    
    private func setupUI() {
        self.commonSetup()
        self.commonTableViewSetup(tableView: self.tableView, cells: [ObjectShortCellView.self])
        self.tableView.register(UINib(nibName: String(describing: TitleTableHeader.self), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: TitleTableHeader.self))
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.viewModel.updateBookings()
    }
    
    @objc func getBookings() {
        if self.sections.isEmpty {
            self.viewModel.updateBookings()
        }
    }
    
}

extension BookingsController: BookingListView {
    func error(_ message: String) {
        self.openErrorAlert(message: message)
    }
    
    func setupFavoriteLoading(_ id: Int?) {
        self.favoriteLoadingID = id
        self.tableView.reloadData()
    }
    
    func setupLoading(_ isLoading: Bool) {
        if !isLoading { self.refreshControl.endRefreshing() }
        self.emptyView.alpha = isLoading ? 0 : (self.sections.isEmpty ? 1 : 0) 
//        isLoading ? self.loader.startAnimating() : self.loader.stopAnimating()
    }
    
    func setupBookings(_ bookings: [BookingModel]) {
        self.sections.removeAll()
        self.emptyView.alpha = bookings.isEmpty ? 1 : 0
        self.tableView.alpha = bookings.isEmpty ? 0 : 1
        let bookTypes = DefinitionManager.shared.bookingTypes
        for type in bookTypes {
            let filteredBookings = bookings.filter({$0.stateID == type.id})
            if !filteredBookings.isEmpty {
                self.sections.append(BookingListSectionModel(title: type.title, objects: filteredBookings.map({$0})))
            }
        }
        self.tableView.reloadData()
    }
}

extension BookingsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TitleTableHeader") as! TitleTableHeader
        view.isLeftPadding = true
        view.titleLabel.text = self.sections[section].title
        return view
   }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == (self.sections.count-1), indexPath.row == self.sections[indexPath.section].objects.count - 1 { // last cell
            //if totalItems > privateList.count { //removing totalItems for always service call
            self.viewModel.getBookings()
            //}
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ObjectShortCellView.self), for: indexPath) as? ObjectShortCellView {
            cell.isBigPadding = false
            if let object = self.sections[indexPath.section].objects[indexPath.row].object {
                cell.setupModel(object, isFavorite: false)
                cell.objectShortView.favoriteButton.setupLoading(object.id == self.favoriteLoadingID)
            }
            cell.action = { [unowned self] in
                if let id = self.sections[indexPath.section].objects[indexPath.row].id {
                    BookingDetailController.openBookingDetailController(viewController: self, id: id)
                }
            }
            cell.objectShortView.favoriteAction = { [unowned self] in
                if let id = self.sections[indexPath.section].objects[indexPath.row].objectID {
                    self.viewModel.favoriteEvent(id)
                }
            }
            return cell
        }
        return UITableViewCell()
    }

}
