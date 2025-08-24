//
//  CityCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 20.06.2022.
//

import Foundation
import UIKit
import Kingfisher

class CityCellView: CustomXibCollectionViewCell {
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setupViews() {
        super.setupViews()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        self.gradientView.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
    
    func setupModel(_ model: ListCellModel) {
        self.pictureImageView.image = nil
        if let picture = model.picture, let url = URL(string: picture) {
            self.pictureImageView.kf.indicatorType = .activity
            self.pictureImageView.kf.setImage(with: url)
        } else {
            self.pictureImageView.image = UIImage(named: "template_object")!
        }
        self.nameLabel.text = model.title
        self.countLabel.text = model.descr
    }
    
}
