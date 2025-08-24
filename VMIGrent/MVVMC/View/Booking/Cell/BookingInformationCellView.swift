//
//  BookingInformationCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 09.07.2022.
//

import Foundation
import UIKit

class BookingInformationCellView: UITableViewCell {
    
    @IBOutlet weak var dateStartLabel: UILabel!
    @IBOutlet weak var timeStartLabel: UILabel!
    @IBOutlet weak var dateEndLabel: UILabel!
    @IBOutlet weak var timeEndLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    func setupCell() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.f2f2f2
    }
    
    func setupModel(_ model: BookingInformationCellViewModel) {
        self.dateStartLabel.text = model.startDate
        self.timeStartLabel.text = model.startTime
        self.dateEndLabel.text = model.endDate
        self.timeEndLabel.text = model.endTime
    }
    
}
