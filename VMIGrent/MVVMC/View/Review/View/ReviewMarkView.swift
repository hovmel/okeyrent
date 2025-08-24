//
//  ReviewMarkView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 22.07.2022.
//

import Foundation
import UIKit

class ReviewMarkView: CustomXibView {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet var stars: [ReviewStarButton]!
    
    var type: ReviewRateType = .LOCATION
    
    var action: ((ReviewRateType, Int) -> ())?
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .clear
        self.view.backgroundColor = .clear
        for (index,star) in self.stars.enumerated() {
            star.tag = index
        }
    }
    
    func setupModel(model: ReviewCellViewModel) {
        self.type = model.id
        self.title.text = model.id.title
        self.setupMark(model.rate)
    }
    
    private func setupMark(_ mark: Int) {
        guard mark > 0 else {return}
        self.stars.forEach({$0.isSelected = (mark-1) >= $0.tag})
    }
    
    @IBAction func starPressed(sender: UIButton) {
        let mark = sender.tag + 1
        self.setupMark(mark)
        self.action?(self.type, mark)
    }
    
}
