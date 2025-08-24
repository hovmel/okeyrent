//
//  ObjectShortView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.07.2022.
//

import UIKit
import Kingfisher

class ObjectShortView: CustomXibView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rateView: RateView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: FavoriteButton!
    
    var favoriteAction: (() -> ())?
    var action: (() -> ())?
    
    override func setupViews() {
        super.setupViews()
        self.imageView.layer.cornerRadius = 20

        self.view.layer.cornerRadius = 20
        self.view.clipsToBounds = true
        self.view.backgroundColor = Colors.white
        self.backgroundColor = .clear
        self.makeCenterShadow()
    }
    
    func setupModel(_ model: ObjectModel) {
        self.imageView.image = nil
        if let picture = model.picture?.original, let url = URL(string: picture) {
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: url)
        } else {
            self.imageView.image = UIImage(named: "template_object")!
        }
        self.rateView.rateLabel.text = "\(model.rate ?? 0.0)"
        self.titleLabel.text = model.name
        self.addressLabel.text = model.address
        self.priceLabel.text = model.priceDay?.price ?? ""
        self.favoriteButton.isSelected = model.inFavorite ?? false
        
//        self.rateView.isHidden = model.rate == 0
    }
    
    func setupModel(_ model: ObjectShortModel) {
        self.imageView.image = nil
        if let picture = model.picture?.original, let url = URL(string: picture){
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: url)
        } else {
            self.imageView.image = UIImage(named: "template_object")!
        }
        self.rateView.rateLabel.text = "\(model.rate)"
        self.titleLabel.text = model.name
        self.addressLabel.text = model.address
        self.priceLabel.text = model.priceDay.price
        self.favoriteButton.isSelected = model.inFavorite
        
//        self.rateView.isHidden = model.rate == 0
    }
    
    @IBAction func favoritePressed() {
        self.favoriteAction?()
    }
    
    @IBAction func viewPressed() {
        self.action?()
    }
    
}
