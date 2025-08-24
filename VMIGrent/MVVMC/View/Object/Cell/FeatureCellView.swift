//
//  FeatureCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 06.07.2022.
//

import Foundation
import UIKit

class FeatureCellView: UITableViewCell {
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    func setupCell() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.f2f2f2
    }
    
    func setupModel(_ model: FeatureModel) {
        self.nameLabel.text = model.name
        self.logoView.image = model.image
    }
    
}
