//
//  FieldCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 01.06.2022.
//

import Foundation
import UIKit

class FieldCellView: UITableViewCell {
    
    @IBOutlet weak var fieldView: FieldView!
    
    var action: ((String) -> ())?
    
    func setupModel(_ model: RegisterCellModel) {
        self.fieldView.titleLabel.text = model.title
        switch model.type {
        case .phone:
            self.fieldView.phoneField.text = model.value
        default:
            self.fieldView.textField.text = model.value
        }
        self.fieldView.type = model.type
        self.fieldView.action = { text in
            self.action?(text)
        }
        self.fieldView.phoneField.isEnabled = model.isEnabled
        self.fieldView.textField.isEnabled = model.isEnabled
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = UITableViewCell.SelectionStyle.none
        self.backgroundColor = Colors.f2f2f2
        self.fieldView.textField.setLeftPaddingPoints(15)
        self.fieldView.textField.setRightPaddingPoints(15)
    }
    
    
}
