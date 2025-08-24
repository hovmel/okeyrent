//
//  ObjectListCell.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 22.06.2022.
//

import Foundation
import UIKit

class ObjectListCell: UITableViewCell {
    
    @IBOutlet weak var favotiteButton: FavoriteButton!
    @IBOutlet weak var galleryView: GalleryView!
    @IBOutlet weak var objectPropertyView: ObjectPropertyView!
    @IBOutlet weak var rateView: RateView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var typePriceLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    var favoriteAction: (() -> ())?
    var action: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    private func setupCell() {
        self.separatorInset = .zero
        selectionStyle = UITableViewCell.SelectionStyle.none
        self.backgroundColor = Colors.f2f2f2
        self.contentView.backgroundColor = Colors.f2f2f2
        self.clipsToBounds = false
        self.galleryView.layer.cornerRadius = 20
        self.bgView.layer.cornerRadius = 20
        self.galleryView.clipsToBounds = true
        self.bgView.backgroundColor = .white
        self.bgView.makeShadow()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.actionPressed))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    func setupModel(_ model: ObjectShortModel, isFavoriteLoading: Bool) {
        self.favotiteButton.isSelected = model.inFavorite
        self.favotiteButton.setupLoading(isFavoriteLoading)
        self.galleryView.images = model.pictures?.map({ImageCellViewModel(image: $0.picture?.original)}) ?? []
        self.titleLabel.text = model.name
        self.addressLabel.text = model.address
        self.priceLabel.text = model.priceDay.price
        self.typePriceLabel.text = "/сутки"
        self.rateView.rateLabel.text = "\(model.rate)"
        self.objectPropertyView.setupModel(guests: model.guestsCounter,
                                           beds: model.bedsCounter,
                                           rooms: model.roomsCounter,
                                           size: model.area,
                                           bedrooms: model.bedroomsCounter)
    }
    
    @objc func actionPressed() {
        self.action?()
    }
    
    @IBAction func favoritePressed() {
        self.favoriteAction?()
    }
    
}
