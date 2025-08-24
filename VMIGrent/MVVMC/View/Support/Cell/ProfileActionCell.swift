//
//  ProfileActionCell.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 26.06.2022.
//

import Foundation
import UIKit

class ProfileActionCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    
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
