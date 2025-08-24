//
//  FavoriteButton.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 30.06.2022.
//

import Foundation
import UIKit

class FavoriteButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    @IBInspectable
    var isBig: Bool = false {
        didSet {
            self.setupUI()
            self.setNeedsDisplay()
        }
    }
    
    private func setupUI() {
        self.setImage(self.isBig ? UIImage(named: "favorite")! : UIImage(named: "favorite_small")!, for: .normal)
        self.setImage(self.isBig ? UIImage(named: "favorite_selected")! : UIImage(named: "favorite_small_selected")!, for: .selected)
        self.tintColor = .clear
//        self.setTitle("В избранное", for: .normal)
//        self.setTitleColor(self.isAlwaysLight ? Config.Colors.darkGray : Config.Colors.mainTextColor, for: .normal)
//        self.titleLabel?.font = Config.Fonts.paragraph
//        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
//        self.tintColor = Config.Colors.mainRed
//        self.backgroundColor = .clear
    }
    
    var activityIndicator: UIActivityIndicatorView?
    
    func setupLoading(_ isLoading: Bool) {
        self.setImage(nil, for: .normal)
        self.setImage(nil, for: .disabled)
        guard let _ = self.activityIndicator else {
            if !isLoading {
                self.setupUI()
                return
            }
            self.activityIndicator = UIActivityIndicatorView(style: .white)
            self.activityIndicator!.hidesWhenStopped = true
            self.activityIndicator!.color = Colors.white
            self.activityIndicator!.startAnimating()
            self.activityIndicator!.frame = self.bounds
            self.addSubview(self.activityIndicator!)
            return
        }
        self.isEnabled = !isLoading
        self.activityIndicator!.color = Colors.white
        if isLoading {
            self.setImage(nil, for: .normal)
            self.setImage(nil, for: .selected)
            self.activityIndicator?.startAnimating()
        } else {
            self.setupUI()
            self.activityIndicator?.removeFromSuperview()
        }
    }
    
}
