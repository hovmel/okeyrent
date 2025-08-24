//
//  ProfileCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 06.06.2022.
//

import UIKit
import Kingfisher

class ProfileCellView: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setupModel(_ model: ProfileCellModel) {
        if let url = URL(string: model.photo) {
            self.photoImageView.kf.setImage(with: url)
        }
        self.nameLabel.text = model.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    private func setupCell() {
        self.separatorInset = .zero
        selectionStyle = UITableViewCell.SelectionStyle.none
        self.backgroundColor = Colors.f2f2f2
        self.photoImageView.layer.cornerRadius = 20
    }
    
}
