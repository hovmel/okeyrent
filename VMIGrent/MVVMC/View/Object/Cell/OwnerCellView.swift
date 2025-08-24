//
//  OwnerCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.07.2022.
//

import Foundation
import UIKit
import Kingfisher

class OwnerCellView: UITableViewCell {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    func setupCell() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.f2f2f2
        self.logoImageView.layer.cornerRadius = 12
    }
    
    func setupModel(_ model: ObjectModel) {
        if let image = model.owner?.picture, let url = URL(string: image.original) {
            self.logoImageView.kf.setImage(with: url)
        }
        self.nameLabel.text = model.owner?.name ?? ""
//        self.typeLabel.text = model.owner.
    }
    
}
