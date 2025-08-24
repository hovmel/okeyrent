//
//  ProfileImageCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 08.06.2022.
//

import Foundation
import UIKit
import Kingfisher

class ProfileImageCellView: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descrLabel: UILabel!
    
    func setupIcon(icon: String?, iconData: UIImage?) {
        if let data = iconData {
            self.iconImageView.image = data
            self.descrLabel.text = "Изменить фото профиля"
        } else if let icon = icon, let url = URL(string: icon) {
            self.iconImageView.kf.setImage(with: url)
            self.descrLabel.text = "Изменить фото профиля"
        } else {
            self.descrLabel.text = "Загрузить фото профиля"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    private func setupCell() {
        self.separatorInset = .zero
        self.iconImageView.layer.cornerRadius = 20
        selectionStyle = UITableViewCell.SelectionStyle.none
        self.backgroundColor = Colors.f2f2f2
    }
    
}
