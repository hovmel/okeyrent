//
//  RegionCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 20.07.2022.
//

import Foundation
import UIKit

class RegionCellView: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = UITableViewCell.SelectionStyle.none
        self.backgroundColor = Colors.f2f2f2
    }
    
    func setupTitle(_ title: String) {
        self.titleLabel.text = title
    }
    
}
