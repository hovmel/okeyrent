//
//  BookingRulesCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 12.07.2022.
//

import Foundation
import UIKit

class BookingRulesCellView: UITableViewCell {
    
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var cancelButton: VmigButton!
    @IBOutlet weak var endButton: VmigButton!
    @IBOutlet weak var callButton: VmigButton!
    @IBOutlet weak var reviewButton: VmigButton!
    @IBOutlet weak var detailButton: VmigButton!
    
    var cancelAction: (() -> ())?
    var endAction: (() -> ())?
    var callAction: (() -> ())?
    var reviewAction: (() -> ())?
    var detailAction: (() -> ())?
    var moreAction: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    func setupCell() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.f2f2f2
        self.cancelButton.isEnabled = true
        self.endButton.isEnabled = true
        self.callButton.isEnabled = true
        self.reviewButton.isEnabled = true
        self.detailButton.isEnabled = true
        self.cancelButton.action = { [unowned self] in
            self.cancelAction?()
        }
        self.endButton.action = { [unowned self] in
            self.endAction?()
        }
        self.callButton.action = { [unowned self] in
            self.callAction?()
        }
        self.reviewButton.action = { [unowned self] in
            self.reviewAction?()
        }
        self.detailButton.action = { [unowned self] in
            self.detailAction?()
        }
    }
    
    func setupModel(_ model: BookingRulesCellModel) {
        self.descrLabel.text = model.descr
        self.cancelButton.isHidden = !model.isCancel
        self.endButton.isHidden = !model.isEnd
        self.callButton.isHidden = !model.isCall
        self.reviewButton.isHidden = !model.isReview
        self.detailButton.isHidden = !model.isDetail
    }
    
    @IBAction func morePressed() {
        self.moreAction?()
    }
    
}
