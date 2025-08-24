//
//  ObjectSummaryCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 02.07.2022.
//

import UIKit

class ObjectSummaryCellView: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var objectPropertyView: ObjectPropertyView!
    @IBOutlet weak var rateView: RateView!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var rateStackView: UIStackView!
    
    var mapAction: (() -> ())?
    
    var isShort: Bool = false {
        didSet {
            self.objectPropertyView.isHidden = isShort
            self.rateStackView.isHidden = isShort
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    func setupCell() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.f2f2f2
    }
    
    func setupModel(_ model: ObjectModel) {
        self.titleLabel.text = model.name
        self.addressLabel.text = model.address
        self.objectPropertyView.setupModel(guests: model.guestsCounter ?? 0,
                                           beds: model.bedsCounter ?? 0,
                                           rooms: model.roomsCounter ?? 0,
                                           size: model.area ?? 0,
                                           bedrooms: model.bedroomsCounter ?? 0)
        self.rateView.rateLabel.text = "\(model.rate ?? 0.0)"
        self.rateButton.setTitle("\(model.reviewsCounter ?? 0) отзывов", for: .normal)
        
        self.rateButton.isHidden = model.reviewsCounter == 0
//        self.rateView.isHidden = model.rate == 0
        self.rateStackView.isHidden = self.rateButton.isHidden && self.rateView.isHidden
    }
    
    func setupModel(_ model: ObjectShortModel) {
        self.titleLabel.text = model.name
        self.addressLabel.text = model.address
        self.objectPropertyView.setupModel(guests: model.guestsCounter,
                                           beds: model.bedsCounter,
                                           rooms: model.roomsCounter,
                                           size: model.area,
                                           bedrooms: model.bedroomsCounter)
        self.rateView.rateLabel.text = "\(model.rate)"
        self.rateView.isHidden = true
    }
    
    @IBAction func mapPressed() {
        self.mapAction?()
    }
    
}
