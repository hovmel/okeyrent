//
//  MapPointView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 22.06.2022.
//

import Foundation
import UIKit

class MapPointView: UIView {
    
    class func instanceFromNib() -> MapPointView {
        return UINib(nibName: "MapPointView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MapPointView
    }

    init(price: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.priceLabel.text = price
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pointImageView: UIImageView!
    
    var action: ((Int) -> ())?
    
    func setupViews() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 5
        self.clipsToBounds = false
        self.priceView.layer.cornerRadius = 5
        self.priceView.backgroundColor = .white
        self.pointImageView.tintColor = .white
        self.makeLightShadow()
    }
    
    func setupPrice(_ price: String) {
        self.priceLabel.text = price
    }
    
    func setSelected(_ isSelected: Bool) {
        self.priceView.backgroundColor = isSelected ? Colors.main : .white
        self.priceLabel.textColor = isSelected ? .white : Colors.mainBlack
        self.pointImageView.tintColor = isSelected ? Colors.main : .white
    }
    
}
