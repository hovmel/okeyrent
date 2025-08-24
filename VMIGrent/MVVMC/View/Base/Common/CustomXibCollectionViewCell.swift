//
//  CustomXibCollectionViewCell.swift
//  GLC
//
//  Created by Михаил on 05.09.2018.
//  Copyright © 2018 Duotek. All rights reserved.
//

import UIKit

class CustomXibCollectionViewCell: UICollectionViewCell {
    
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        setupViews()
    }
    
    func loadViewFromNib() -> UIView {
        let className: Swift.AnyClass = type(of:self)
        let bundle = Bundle(for: className)
        let nib = UINib(nibName: String(describing: className), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func setupViews() {}
    
}
