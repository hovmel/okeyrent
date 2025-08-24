//
//  ObjectDescriptionCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.07.2022.
//

import Foundation
import UIKit

class ObjectDescriptionCellView: UITableViewCell {
    
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: MainButton!
    
    var action: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    func setupCell() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.f2f2f2
    }
    
    func setupModel(title: String? = nil, descr: String, isButton: Bool = false) {
        self.descrLabel.text = descr
        self.titleLabel.isHidden = title == nil
        self.titleLabel.text = title
        self.actionButton.isHidden = true
//        self.actionButton.isHidden = !isButton
    }
    
    @IBAction func actionPressed() {
        self.action?()
    }
    
}
