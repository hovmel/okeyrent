//
//  FilterPriceCell.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 28.06.2022.
//

import UIKit
import MultiSlider

class FilterPriceCell: UITableViewCell {
    
    @IBOutlet weak var minPriceLabel: UILabel!
    @IBOutlet weak var maxPriceLabel: UILabel!
    @IBOutlet weak var priceSlider: MultiSlider!
    
    var minAction: ((Int) -> ())?
    var maxAction: ((Int) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    func setupCell() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.f2f2f2
        self.priceSlider.backgroundColor = Colors.f2f2f2
        self.priceSlider.minimumValue = 0   // default is 0.0
        self.priceSlider.maximumValue = 20000    // default is 1.0
        self.priceSlider.thumbTintColor = Colors.main
        self.minPriceLabel.text = 0.price
        self.maxPriceLabel.text = 20000.price

        self.priceSlider.outerTrackColor = Colors.DDDDDD
        self.priceSlider.tintColor = Colors.main // color of track
        self.priceSlider.trackWidth = 4
        self.priceSlider.hasRoundTrackEnds = true
        self.priceSlider.showsThumbImageShadow = true
        self.priceSlider.snapStepSize = 100
//        self.priceSlider.value = [0, 20000]

        self.priceSlider.addTarget(self, action: #selector(self.sliderChanged(slider:)), for: .valueChanged) // continuous changes
//        self.priceSlider.addTarget(self, action: #selector(sliderDragEnded(_:)), for: . touchUpInside) // sent when drag ends
        
        self.priceSlider.orientation = .horizontal // default is .vertical
        self.priceSlider.isVertical = false // same effect, but accessible from Interface Builder
    }
    
    @objc func sliderChanged(slider: MultiSlider) {
        switch slider.draggedThumbIndex {
        case 0:
            self.minPriceLabel.text = (Int(slider.value[0])*100).price
        default:
            self.maxPriceLabel.text = (Int(slider.value[1])*100).price
        }
        self.minAction?(Int(slider.value[0])*100)
        self.maxAction?((Int(slider.value[1])*100))
    }
}
