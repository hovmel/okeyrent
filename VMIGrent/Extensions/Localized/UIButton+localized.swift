//
//  UIButton+localized.swift
//  Abonent
//
//  Created by Mikhail Koroteev on 16.12.2020.
//

import UIKit

extension UIButton {
    
    @IBInspectable public var localizedText : String? {
        set {
            guard let newValue = newValue else {
                return
            }
            self.setTitle(newValue.localized(), for: .normal)
        }
        
        get {
            return self.titleLabel?.text
        }
    }
    
}
