//
//  RegionsController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 20.07.2022.
//

import Foundation
import UIKit

class RegionsController: KeyboardController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: CommonField!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var viewModel: RegionsViewModel!
    
    var action: ((CityModel) -> ())?
    
    var cities: [CityModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = RegionsViewModel(view: self)
        self.setupUI()
        self.viewModel.getCities()
    }
    
    private func setupUI() {
        self.commonSetup()
        self.commonTableViewSetup(tableView: self.tableView, cells: [RegionCellView.self])
        self.searchField.type = .search
        self.searchField.action = { [weak self] text in
            guard let self = self else {return}
            self.viewModel.search = text
        }
    }
    
    override func hideTap() {}
    
    override func changeKeyboardHeight(_ keyboardHeight: CGFloat) {
        self.tableView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 0,
                                                   bottom: keyboardHeight,
                                                   right: 0)
    }
    
}

extension RegionsController: RegionsView {

    func setupLoading(_ isLoading: Bool) {
        isLoading ? self.loader.startAnimating() : self.loader.stopAnimating()
    }
    
    func setCities(_ cities: [CityModel]) {
        self.cities = cities
        self.tableView.reloadData()
    }

}

extension RegionsController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.cities.count - 1 { // last cell
            //if totalItems > privateList.count { //removing totalItems for always service call
            self.viewModel.getCities()
            //}
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RegionCellView.self), for: indexPath) as? RegionCellView {
            cell.setupTitle(self.cities[indexPath.row].name + "\(self.cities[indexPath.row].region?.name != nil ? ", \(self.cities[indexPath.row].region?.name ?? "")" : "")")
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.action?(self.cities[indexPath.row])
        self.dismiss(animated: true)
    }
}
