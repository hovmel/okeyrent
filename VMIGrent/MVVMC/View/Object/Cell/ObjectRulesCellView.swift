//
//  ObjectRulesCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 06.07.2022.
//

import Foundation
import UIKit

class ObjectRulesCellView: UITableViewCell {
    
    @IBOutlet weak var startStackView: UIStackView!
    @IBOutlet weak var endStackView: UIStackView!
    @IBOutlet weak var timeStackView: UIStackView!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    func setupCell() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.f2f2f2
    }
    
    func setupModel(_ model: ObjectRulesCellModel) {
        if let startFrom = model.startFromTime, let startTo = model.startToTime {
            self.startTime.text = "c \(startFrom.makeTime()) до \(startTo.makeTime())"
        } else if let startFrom = model.startFromTime {
            self.startTime.text = "c \(startFrom.makeTime())"
        } else if let startTo = model.startToTime {
            self.startTime.text = "до \(startTo.makeTime())"
        } else {
            self.startStackView.isHidden = true
        }
        
        if let endTime = model.endTime {
            self.endTime.text = "до \(endTime.makeTime())"
        } else {
            self.endStackView.isHidden = true
        }
        
        self.timeStackView.isHidden = self.endStackView.isHidden && self.startStackView.isHidden
        
        if let descr = model.descr {
            self.descrLabel.text = descr
        } else {
            self.descrLabel.isHidden = true
        }
    }
    
}
