//
//  PriceView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.07.2022.
//

import UIKit

class PriceView: CustomXibView {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func setupViews() {
        super.setupViews()
        self.view.backgroundColor = .clear
        self.backgroundColor = .clear
    }
    
    func setupPrice(_ price: Int) {
        self.priceLabel.text = price.price
    }
    
}
