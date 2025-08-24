//
//  ButtonCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 07.07.2022.
//

import Foundation
import UIKit

class ButtonCellView: UITableViewCell {
    
    @IBOutlet weak var actionButton: MainButton!
    
    var action: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    private func setupCell() {
        self.separatorInset = .zero
        selectionStyle = UITableViewCell.SelectionStyle.none
        self.backgroundColor = Colors.f2f2f2
    }
    
    func setupButton(title: String, image: UIImage?) {
        self.actionButton.setTitle(title, for: .normal)
        self.actionButton.setImage(image, for: .normal)
//        self.actionButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.actionButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: image == nil ? 0 : 8, bottom: 0, right: image == nil ? 0 : -8)
    }
    
    @IBAction func actionPressed() {
        self.action?()
    }
    
}
