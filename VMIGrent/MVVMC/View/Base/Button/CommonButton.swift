//
//  CommonButton.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 25.05.2022.
//

import Foundation
import UIKit

class CommonButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    @IBInspectable
    var isUppercased: Bool = true

    @IBInspectable
    var background: Int = 0 {
        didSet {
            self.setBGColor()
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var titleColor: Int = 0 {
        didSet {
            self.setTitleColor()
            self.setNeedsDisplay()
        }
    }
    
    func setTitleColor() {
        let color = Colors.getColor(self.titleColor)
        self.setTitleColor(color, for: .normal)
    }
    
    func setBGColor() {
        let color = Colors.getColor(self.background)
        self.backgroundColor = color
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 20
        self.setTitleColor(Colors.white, for: .normal)
        self.setTitleColor(Colors.white, for: .disabled)
        self.setTitleColor(Colors.white.withAlphaComponent(0.5), for: .focused)
        self.backgroundColor = Colors.main
        self.titleLabel?.font = Fonts.regular(size: 16)
        self.clipsToBounds = true
    }
    
    override var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.setBGColor()
            } else {
                self.backgroundColor = Colors.gray
            }
        }
    }
    
    var activityIndicator: UIActivityIndicatorView?
    
    func setupLoading(_ isLoading: Bool) {
        guard let _ = self.activityIndicator else {
            if !isLoading {
                return
            }
            self.tintColor = .clear
            self.setTitleColor(.clear, for: .normal)
            self.activityIndicator = UIActivityIndicatorView(style: .white)
            self.activityIndicator!.color = .white
            self.activityIndicator!.startAnimating()
            self.activityIndicator!.frame = self.bounds
            self.addSubview(self.activityIndicator!)
            return
        }
        self.isEnabled = !isLoading
        self.activityIndicator!.color = .white
        if isLoading {
            self.tintColor = .clear
            self.setTitleColor(.clear, for: .normal)
            self.activityIndicator?.startAnimating()
        } else {
            self.tintColor = Colors.white
            self.setTitleColor(Colors.white, for: .normal)
            self.activityIndicator?.stopAnimating()
        }
    }
    
//    override var isHighlighted: Bool {
//        didSet {
//            guard oldValue != self.isHighlighted else { return }
//            UIView.animate(withDuration: 0.05, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
//                self.alpha = self.isHighlighted ? 0.75 : 1
//            }, completion: nil)
//        }
//    }
}
