//
//  ObjectPropertyView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 23.06.2022.
//

import Foundation
import UIKit

class ObjectPropertyView: CustomXibView {
    
    @IBOutlet weak var guestsLabel: UILabel!
    @IBOutlet weak var guestsTitleLabel: UILabel!
    @IBOutlet weak var bedsLabel: UILabel!
    @IBOutlet weak var bedsTitleLabel: UILabel!
    @IBOutlet weak var roomsLabel: UILabel!
    @IBOutlet weak var roomsTitleLabel: UILabel!
    @IBOutlet weak var bedroomsLabel: UILabel!
    @IBOutlet weak var bedroomsTitleLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var guestsStackView: UIStackView!
    @IBOutlet weak var bedsStackView: UIStackView!
    @IBOutlet weak var roomsStackView: UIStackView!
    @IBOutlet weak var bedroomsStackView: UIStackView!
    
    func setupModel(guests: Int, beds: Int, rooms: Int, size: Int, bedrooms: Int) {
        self.guestsLabel.text = "\(guests)"
        self.bedsLabel.text = "\(beds)"
        self.roomsLabel.text = "\(rooms)"
        self.bedroomsLabel.text = "\(bedrooms)"
        self.sizeLabel.text = "\(size)м²"
        
        self.guestsTitleLabel.text = String.makeGuests(guests, withNumber: false)
        self.bedsTitleLabel.text = String.makeBeds(beds, withNumber: false)
        self.roomsTitleLabel.text = String.makeRooms(rooms, withNumber: false)
        self.bedroomsTitleLabel.text = String.makeBedrooms(bedrooms, withNumber: false)
        
        self.guestsStackView.isHidden = guests == 0
        self.bedsStackView.isHidden = beds == 0
        self.roomsStackView.isHidden = rooms == 0
        self.bedroomsStackView.isHidden = bedrooms == 0
    }
    
    override func setupViews() {
        self.view.backgroundColor = .clear
        self.backgroundColor = .clear
    }
    
}
