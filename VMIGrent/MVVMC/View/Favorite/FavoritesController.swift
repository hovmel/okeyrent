//
//  FavoritesController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 29.06.2022.
//

import UIKit

class FavoritesController: UIViewController {
    
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var emptyView: EmptyView!
    
    var viewModel: FavoritesViewModel!
    
    var objects: [ObjectShortModel] = []
    
    var favoriteLoadingID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = FavoritesViewModel(view: self)
        self.setupUI()
        if AuthManager.shared.authComplete() {
            self.viewModel.getFavorites()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.getFavorites), name: .openedFavorites, object: nil)
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
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.viewModel.getFavorites()
    }
    
    @objc func getFavorites() {
//        if self.objects.isEmpty {
            self.viewModel.getFavorites()
//        }
    }
    
}

extension FavoritesController: FavoritesView {
    func setupFavoriteLoading(_ isLoading: Bool, id: Int?) {
        self.favoriteLoadingID = id
        self.tableView.reloadData()
    }
    
    
    func error(_ message: String) {
        self.openErrorAlert(message: message)
    }
    
    func setupFavorites(_ objects: [ObjectShortModel]) {
        self.favoriteLoadingID = nil
        self.emptyView.alpha = objects.isEmpty ? 1 : 0
        self.tableView.alpha = objects.isEmpty ? 0 : 1
        self.objects = objects
        self.tableView.reloadData()
    }
    
    func setupLoading(_ isLoading: Bool) {
        isLoading ? self.refreshControl.beginRefreshing() : self.refreshControl.endRefreshing()
        self.emptyView.alpha = isLoading ? 0 : (self.objects.isEmpty ? 1 : 0) 
//        isLoading ? self.loader.startAnimating() : self.loader.stopAnimating()
    }

}

extension FavoritesController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ObjectShortCellView.self), for: indexPath) as? ObjectShortCellView {
            cell.isBigPadding = false
            cell.setupModel(self.objects[indexPath.row])
            cell.action = { [unowned self] in
                ObjectController.openObjectController(viewController: self, id: self.objects[indexPath.row].id, filterModel: FilterModel())
            }
            cell.objectShortView.favoriteButton.setupLoading(self.objects[indexPath.row].favoriteID == self.favoriteLoadingID)
            cell.objectShortView.favoriteAction = { [unowned self] in
                self.viewModel.removeFavorite(id: self.objects[indexPath.row].id)
            }
            return cell
        }
        return UITableViewCell()
    }
    
}


