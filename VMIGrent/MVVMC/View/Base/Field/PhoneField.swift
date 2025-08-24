//
//  PhoneField.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 01.06.2022.
//

import Foundation
import UIKit
import SHSPhoneComponent

class PhoneField: SHSPhoneTextField {
    
    var action: ((String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    private func setupUI() {
        self.borderStyle = .none
        self.backgroundColor = Colors.white
        self.layer.borderColor = Colors.e3e3e3.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        self.textColor = Colors.mainBlack
        self.attributedPlaceholder = NSAttributedString(
            string: "+7",
            attributes: [NSAttributedString.Key.foregroundColor: Colors.e3e3e3]
        )
        self.font = Fonts.regular(size: 16)
        self.setLeftPaddingPoints(15)
        self.setRightPaddingPoints(15)
        self.addReadyButton()
        self.clipsToBounds = true
        self.delegate = self
        self.formatter.setDefaultOutputPattern("+7 ### ###-##-##")
        self.placeholder = "+7 "
    }
    
}

extension PhoneField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, text.count > 3 else {
            self.text = "+7 "
            return false
        }
        
        self.action?(text)
        
        return true
    }
}
