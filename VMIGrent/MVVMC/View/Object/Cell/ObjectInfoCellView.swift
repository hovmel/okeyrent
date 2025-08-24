//
//  ObjectInfoCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 21.07.2022.
//

import Foundation
import UIKit

class ObjectInfoCellView: UITableViewCell {
    
    @IBOutlet weak var textViewHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    func setupCell() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.f2f2f2
        self.textView.font = Fonts.regular(size: 14)
        self.textView.isEditable = false
        self.textView.dataDetectorTypes = .link
        self.textView.textContainer.lineFragmentPadding = 0
        self.textView.textContainerInset =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func setupText(_ text: String) {
        self.textView.text = text
        self.textViewHeightConstr.constant = text.getEstimatedHeight(UIScreen.main.bounds.width - 32,
                                                                     font: Fonts.regular(size: 14))
    }
    
}
