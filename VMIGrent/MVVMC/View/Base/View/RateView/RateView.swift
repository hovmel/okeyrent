//
//  RateView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 29.06.2022.
//

import Foundation
import UIKit

class RateView: CustomXibView {
    
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBInspectable
    var isBig: Bool = true {
        didSet {
            self.rateLabel.font = Fonts.regular(size: self.isBig ? 12 : 10)
            self.setNeedsDisplay()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        self.view.backgroundColor = Colors.main
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height/2
    }
    
}
