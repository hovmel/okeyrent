//
//  CustomXibView.swift
//  GLC
//
//  Created by Михаил on 05.09.2018.
//  Copyright © 2018 Duotek. All rights reserved.
//

import UIKit

class CustomXibView: UIView {
    
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
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        view.backgroundColor = Colors.f2f2f2
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
    
    func closeView(_ completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            self.alpha = 0
            }, completion: { _ in
                completion()
        })
    }
}
