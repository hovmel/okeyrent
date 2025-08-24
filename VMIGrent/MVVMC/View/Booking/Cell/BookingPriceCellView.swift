//
//  BookingPriceCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 10.07.2022.
//

import Foundation
import UIKit

class BookingPriceCellView: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var models: [PriceModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    func setupCell() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.f2f2f2
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(UINib(nibName: String(describing: PriceCellView.self), bundle: nil),
                                forCellReuseIdentifier: String(describing: PriceCellView.self))
        self.tableView.backgroundColor = Colors.f2f2f2
    }
    
    func setupModels(total: PriceModel, models: [PriceModel], title: String? = nil) {
        self.totalLabel.text = total.price.price
        self.totalTitleLabel.text = total.title
        self.models = models
        self.tableViewHeight.constant = CGFloat(24 * models.count)
        self.tableView.isHidden = models.count == 0
        self.tableView.reloadData()
        if let title = title {
            self.titleLabel.text = title
        }
    }
    
}

extension BookingPriceCellView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PriceCellView.self), for: indexPath) as? PriceCellView {
            cell.setupModel(self.models[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
}
