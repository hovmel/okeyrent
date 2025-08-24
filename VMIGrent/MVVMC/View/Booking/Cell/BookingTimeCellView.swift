//
//  BookingTimeCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.07.2022.
//

import Foundation
import UIKit

class BookingTimeCellView: UITableViewCell {
    
    @IBOutlet weak var dateButton: MainButton!
    @IBOutlet weak var startButton: MainButton!
    @IBOutlet weak var endButton: MainButton!
    @IBOutlet weak var nightsLabel: UILabel!
    
    var dateAction: (() -> ())?
    var startAction: (() -> ())?
    var endAction: (() -> ())?
    
    let calendar = Calendar.current
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    func setupCell() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.f2f2f2
    }
    
    func setupModel(_ model: BookingTimeCellModel) {
        self.dateButton.setTitle(model.dates, for: .normal)
        self.startButton.setTitle(DateFormatter.hoursAndMnutes.string(from: model.startTime), for: .normal)
        self.endButton.setTitle(DateFormatter.hoursAndMnutes.string(from: model.endTime), for: .normal)
        self.nightsLabel.text = model.nights
    }
    
    @IBAction func datePressed() {
        self.dateAction?()
    }
    
    @IBAction func endPressed() {
        self.endAction?()
    }
    
    @IBAction func startPressed() {
        self.startAction?()
    }
    
}
