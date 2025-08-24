//
//  UITextField+localized.swift
//  Abonent
//
//  Created by Mikhail Koroteev on 15.12.2020.
//

import UIKit

extension UITextField {
    @IBInspectable public var placeHolderLocalizedText : String? {
        set {
            guard let newValue = newValue else {
                return
            }
            self.placeholder = newValue.localized()
        }
        
        get {
            return self.text
        }
    }
}
