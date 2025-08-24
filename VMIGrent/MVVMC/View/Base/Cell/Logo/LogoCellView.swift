//
//  LogoCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 08.06.2022.
//

import Foundation
import UIKit

class LogoCellView: UITableViewCell {
    
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
