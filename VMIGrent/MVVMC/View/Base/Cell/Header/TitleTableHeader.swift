//
//  TitleTableHeader.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 29.06.2022.
//

import Foundation
import UIKit

class TitleTableHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var leftPaddingConstr: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    var isLeftPadding: Bool = false {
        didSet {
            self.leftPaddingConstr.constant = isLeftPadding ? 24.0 : 0
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.backgroundColor = Colors.f2f2f2
    }
    
}
