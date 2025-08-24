//
//  CityHeaderCell.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 21.06.2022.
//

import Foundation
import UIKit

class CityHeaderCell: UITableViewCell {
    
    @IBOutlet weak var searchField: CommonField!
    
    var action: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        self.backgroundColor = Colors.f2f2f2
        self.setupCell()
    }
    
    func setupCell() {
        self.searchField.type = .search
    }
    
    @IBAction func serachDidPressed() {
        self.action?()
    }
    
}
