//
//  FilterBedsCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 02.11.2022.
//

import Foundation
import UIKit

fileprivate let max_guests: Int = 100

class FilterBedsCellView: UITableViewCell {
    
    @IBOutlet weak var guestsLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var reduceButton: UIButton!
    
    var addAction: (() -> ())?
    var reduceAction: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    func setupCell() {
        self.backgroundColor = Colors.f2f2f2
        self.selectionStyle = .none
        self.addButton.makeShadow()
        self.reduceButton.makeShadow()
    }
    
    func setGuests(count: Int) {
        self.addButton.isEnabled = count != max_guests
        self.reduceButton.isEnabled = count != 0
        self.guestsLabel.text = "\(count)"
    }
    
    @IBAction func addPressed() {
        self.addAction?()
    }
    
    @IBAction func reducePressed() {
        self.reduceAction?()
    }
    
}
