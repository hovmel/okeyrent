//
//  ObjectFeaturesCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 06.07.2022.
//

import Foundation
import UIKit

class ObjectFeaturesCellView: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstr: NSLayoutConstraint!
    
    var models: [FeatureModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        self.backgroundColor = Colors.f2f2f2
        self.setupCell()
    }
    
    func setModels(_ models: [FeatureModel], title: String? = nil) {
        self.models = models
        self.tableViewHeightConstr.constant = CGFloat(32 * models.count)
        if let title = title {
            self.titleLabel.text = title
        }
    }
    
    private func setupCell() {
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(UINib(nibName: String(describing: FeatureCellView.self), bundle: nil),
                                forCellReuseIdentifier: String(describing: FeatureCellView.self))
        self.tableView.backgroundColor = .clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = Colors.f2f2f2
    }
    
}

extension ObjectFeaturesCellView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FeatureCellView.self), for: indexPath) as? FeatureCellView {
            cell.setupModel(self.models[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
}
