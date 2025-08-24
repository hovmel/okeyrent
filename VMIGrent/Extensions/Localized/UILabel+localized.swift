//
//  UILabel+localized.swift
//  Abonent
//
//  Created by Mikhail Koroteev on 15.12.2020.
//

import UIKit

extension UILabel {
    
    @IBInspectable public var localizedText : String? {
        set {
            guard let newValue = newValue else {
                return
            }
            
            self.text = newValue.localized()
            
            self.layoutSubviews()
            self.setNeedsDisplay()
        }
        
        get {
            return self.text
        }
    }
    
}

