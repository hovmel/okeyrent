//
//  BookingDetailCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 09.07.2022.
//

import Foundation
import UIKit

class BookingDetailCellView: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var guestsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    
    var downloadAction: (() -> ())?
    var copyAction: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    func setupCell() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.f2f2f2
        self.copyButton.setImage(UIImage(named: "copy")!, for: .normal)
    }
    
    func setupModel(_ model: BookingDetailCellModel) {
        self.numberLabel.text = "Номер бронирования \(model.number)"
        self.priceLabel.text = "Общая стоимость: \(model.price)"
        self.guestsLabel.text = String.makeGuests(model.guests)
        self.statusLabel.text = model.status
        self.copyButton.tintColor = Colors.gray
    }
    
    @IBAction func downloadCheckPressed() {
        self.downloadAction?()
    }
    
    @IBAction func copyNumberPressed() {
        self.copyButton.tintColor = Colors.main
        self.copyAction?()
    }
    
}
