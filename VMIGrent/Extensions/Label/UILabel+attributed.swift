//
//  UILabel+attributed.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 30.05.2022.
//

import Foundation
import UIKit

extension UILabel {
 
    func setColored(target: Any?, text: String, subText: [String], action: Selector?) {
        let attribute = NSMutableAttributedString.init(string: text)
        for subText in subText {
            let range = (text as NSString).range(of: subText)
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: Colors.getColor(0) , range: range)
        }
        
        self.attributedText = attribute
        self.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(gesture)
    }
    
}
