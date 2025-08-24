//
//  ObjectReviewCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 20.07.2022.
//

import Foundation
import UIKit
import Kingfisher

class ObjectReviewCellView: CustomXibCollectionViewCell {
    
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var rateView: RateView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var moreButton: MainButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    var action: (() -> ())?
    
    override func setupViews() {
        self.backgroundColor = Colors.f2f2f2
        self.ownerImageView.layer.cornerRadius = 16
        self.view.layer.cornerRadius = 20
        self.backgroundColor = .clear
        self.makeCenterShadow()
        self.clipsToBounds = false
    }
    
    func setupModel(_ model: ReviewModel, isOpened: Bool, isButton: Bool) {
        self.ownerImageView.image = UIImage(named: "profile_default")!
        if let image = model.customer.picture?.original, let url = URL(string: image) {
            self.ownerImageView.kf.setImage(with: url)
        }
        self.ownerNameLabel.text = model.customer.name
        self.rateView.rateLabel.text = "\(model.rate)"
        self.reviewLabel.text = model.review
//        self.moreButton.isHidden = model.review.numberOfLines
        let calendar = Calendar.current
        let monthHeaderDateFormatter = DateFormatter()
        monthHeaderDateFormatter.calendar = calendar
        monthHeaderDateFormatter.locale = Locale(identifier: "ru_RU")
        monthHeaderDateFormatter.dateFormat = DateFormatter.dateFormat(
          fromTemplate: "MMMM yyyy",
          options: 0,
          locale: calendar.locale ?? Locale.current)
        self.dateLabel.text = monthHeaderDateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(model.created_at))).capitalizingFirstLetter()
        self.moreButton.isHidden = !isButton
        self.moreButton.setTitle(isOpened ? "Скрыть" : "Читать полностью", for: .normal)
    }
    
    @IBAction func actionPressed() {
        self.action?()
    }
    
}
