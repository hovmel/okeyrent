//
//  CommonLabel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 25.05.2022.
//

import Foundation
import UIKit

class CommonLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    @IBInspectable
    var isBorder: Bool = false {
        didSet {
            self.layer.borderWidth = isBorder ? 1 : 0
//            self.layer.borderColor = isBorder ? Config.Colors.fieldBorderColor.cgColor : UIColor.clear.cgColor
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var isMediumFont: Bool = false {
        didSet {
            self.setupFont()
        }
    }
    @IBInspectable
    var isBoldFont: Bool = false {
        didSet {
            self.setupFont()
        }
    }
    
    @IBInspectable
    var isCornerRadius: Bool = false {
        didSet {
            self.layer.cornerRadius = 20 // isCornerRadius ? self.frame.size.height/2 : 0
            self.clipsToBounds = true
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var bgColor: Int = 0 {
        didSet {
            let color = Colors.getColor(self.bgColor)
            self.backgroundColor = color
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var color: Int = 0 {
        didSet {
            let color = Colors.getColor(self.color)
            self.textColor = color
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var fontSize: Int = 12 {
        didSet {
            self.setupFont()
            self.setNeedsDisplay()
        }
    }
    
    func setupFont() {
        var font: UIFont
        if self.isBoldFont {
            font = Fonts.bold(size: CGFloat(self.fontSize))
        } else if self.isMediumFont {
            font = Fonts.medium(size: CGFloat(self.fontSize))
        } else {
            font = Fonts.regular(size: CGFloat(self.fontSize))
        }
        self.font = font
    }
    
}
