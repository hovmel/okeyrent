//
//  FieldView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 29.05.2022.
//

import Foundation
import UIKit

enum FieldViewType {
    case simple(CommonFieldType)
    case phone
}


class FieldView: CustomXibView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: CommonField!
    @IBOutlet weak var phoneField: PhoneField!
    
    var type: FieldViewType = .simple(.simple) {
        didSet {
            self.textField.rightView = nil
            self.textField.isHidden = true
            self.phoneField.isHidden = true
            switch self.type {
            case .simple(let type):
                self.textField.type = type
                self.setSimple()
            case .phone:
                self.setPhone()
            }
        }
    }
    
    var action: ((String) -> ())?
    
    private func defaultSetup() {
        self.textField.isHidden = false
        self.textField.action = { text in
            self.action?(text)
        }
    }
    
    private func setSimple() {
        self.defaultSetup()
    }
    
    private func setPhone() {
        self.phoneField.isHidden = false
        self.phoneField.action = { text in
            self.action?(text)
        }
    }
    
    override func setupViews() {
        super.setupViews()
//        self.backgroundColor = .clear
//        self.view.backgroundColor = .clear
        self.textField.setLeftPaddingPoints(15)
        self.textField.setRightPaddingPoints(15)
    }
    
}
