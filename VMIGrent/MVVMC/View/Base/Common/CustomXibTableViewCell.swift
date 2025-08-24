//
//  CustomXibTableViewCell.swift
//  MagicMoments
//
//  Created by Mikhail Koroteev on 03.11.2020.
//  Copyright © 2020 mskMobile. All rights reserved.
//

import UIKit

class CustomXibTableViewCell: UITableViewCell {
    
    var view: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
