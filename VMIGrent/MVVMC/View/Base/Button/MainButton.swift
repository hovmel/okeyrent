//
//  MainButton.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.06.2022.
//

import UIKit

class MainButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    func setupUI() {
        self.setTitleColor(Colors.gray, for: .disabled)
    }
    
    @IBInspectable
    var isMediumFont: Bool = false
    
    @IBInspectable
    var color: Int = 0 {
        didSet {
            let color = Colors.getColor(self.color)
            self.setTitleColor(color, for: .normal)
            self.setTitleColor(color.withAlphaComponent(0.5), for: .focused)
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var fontSize: Int = 12 {
        didSet {
            var font: UIFont
            if self.isMediumFont {
                font = Fonts.medium(size: CGFloat(self.fontSize))
            } else {
                font = Fonts.regular(size: CGFloat(self.fontSize))
            }
            self.titleLabel?.font = font
            self.setNeedsDisplay()
        }
    }
    
    var activityIndicator: UIActivityIndicatorView?
    
    func setupLoading(_ isLoading: Bool) {
        let color = Colors.getColor(self.color)
        guard let _ = self.activityIndicator else {
            if !isLoading {
                return
            }
            self.tintColor = .clear
            self.setTitleColor(.clear, for: .normal)
            self.activityIndicator = UIActivityIndicatorView(style: .white)
            self.activityIndicator!.color = color
            self.activityIndicator!.startAnimating()
            self.activityIndicator!.frame = self.bounds
            self.addSubview(self.activityIndicator!)
            return
        }
        self.isEnabled = !isLoading
        self.activityIndicator!.color = color
        if isLoading {
            self.tintColor = .clear
            self.setTitleColor(.clear, for: .normal)
            self.activityIndicator?.startAnimating()
        } else {
            self.tintColor = color
            self.setTitleColor(color, for: .normal)
            self.activityIndicator?.stopAnimating()
        }
    }
    
}
