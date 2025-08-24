//
//  ProfileMenuCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 06.06.2022.
//

import UIKit

class ProfileMenuCellView: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrLabel: CommonLabel!
    
    func setupModel(_ model: ProfileMenuCellModel) {
        self.titleLabel.text = model.title
        self.descrLabel.isHidden = model.descr == nil
        if let descr = model.descr {
            self.descrLabel.text = descr
        }
        if let color = model.color {
            self.descrLabel.backgroundColor = color
        }
        if let textColor = model.textColor {
            self.descrLabel.textColor = textColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    private func setupCell() {
        self.separatorInset = .zero
        selectionStyle = UITableViewCell.SelectionStyle.none
        self.backgroundColor = Colors.f2f2f2
    }
    
}
