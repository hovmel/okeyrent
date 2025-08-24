//
//  FilterCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 29.06.2022.
//

import Foundation
import UIKit

class FilterCellView: CustomXibCollectionViewCell {
    
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    func setupCell() {
        self.view.backgroundColor = Colors.f2f2f2
        self.backgroundColor = Colors.f2f2f2
        self.selectView.layer.cornerRadius = 5
        self.selectView.layer.borderWidth = 1
        self.selectView.layer.borderColor = Colors.e3e3e3.cgColor
    }
    
    override func setupViews() {
        super.setupViews()
        self.setupCell()
    }
    
    func setSelected(_ isSelected: Bool) {
//        self.selectView.layer.borderWidth = isSelected ? 0 : 1
        self.selectView.backgroundColor = isSelected ? Colors.main : Colors.white
    }
    
    func setupModel(_ model: FilterCellModel) {
        self.titleLabel.text = model.title
        self.setSelected(model.isSelected)
    }
    
}
