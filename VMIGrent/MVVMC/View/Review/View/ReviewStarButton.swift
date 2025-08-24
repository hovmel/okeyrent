//
//  ReviewStarButton.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 22.07.2022.
//

import Foundation
import UIKit

class ReviewStarButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    private func setupUI() {
        self.setImage(UIImage(named: "rate")!, for: .normal)
        self.setImage(UIImage(named: "rate_selected")!, for: .selected)
        self.tintColor = .clear
    }
    
}
