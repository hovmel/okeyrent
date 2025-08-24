//
//  CitiesController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 20.06.2022.
//

import UIKit

enum CitiesControllerSection {
    case search
    case cities([CityModel])
    case rooms([ObjectShortModel])
}

class CitiesController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var viewModel: CitiesViewModel!
    
    var sections: [CitiesControllerSection] {
        var sections: [CitiesControllerSection] = []
        sections.append(.search)
        sections.append(.cities(self.cities))
        if !self.objects.isEmpty {
            sections.append(.rooms(self.objects))
        }
        return sections
    }
    
    var objects: [ObjectShortModel] = []
    
    var cities: [CityModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.viewModel = CitiesViewModel(view: self)
        self.viewModel.getDashboard()
    }
    
    private func setupUI() {
        self.commonSetup()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        self.commonTableViewSetup(tableView: self.tableView, cells: [ListCellView.self, CityHeaderCell.self])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        NotificationCenter.default.post(name: .openMenu, object: nil)
    }
    
}

extension CitiesController: CitiesView {
    func setObjects(_ objects: [ObjectShortModel]) {
        self.objects = objects
        self.tableView.reloadData()
    }
    
    func setupLoading(_ isLoading: Bool) {
        isLoading ? self.loader.startAnimating() : self.loader.stopAnimating()
    }
    
    func setCities(_ cities: [CityModel]) {
        self.cities = cities
    }
}

extension CitiesController: UITableViewDelegate,
                            UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.row]
        switch section {
        case .search:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CityHeaderCell.self),
                                                        for: indexPath) as? CityHeaderCell {
                cell.searchField.text = self.viewModel.search
                cell.action = { [weak self] in
                    guard let self = self else {return}
                    self.openRegionsController { [unowned self] model in
                        MapController.openMapController(viewController: self, city: model)
                    }
                }
                return cell
            }
        case .rooms(let rooms):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ListCellView.self),
                                                        for: indexPath) as? ListCellView {
                
                    cell.setModels(rooms.map({ListCellModel(title: $0.name,
                                                            descr: $0.address,
                                                            picture: $0.picture?.original)}),
                                   title: "Лучшие квартиры",
                                   isStar: true)
                    cell.action = { [unowned self] index in
                        NotificationCenter.default.post(name: .closeMenu, object: nil)
                        ObjectController.openObjectController(viewController: self,
                                                              id: rooms[index].id,
                                                              filterModel: FilterModel())
                    }
                return cell
            }
        case .cities(let cities):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ListCellView.self),
                                                        for: indexPath) as? ListCellView {
                cell.setModels(cities.map({$0.listCellModel}), title: "Города", isStar: false)
                cell.action = { [unowned self] index in
                    MapController.openMapController(viewController: self, city: cities[index])
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
}
