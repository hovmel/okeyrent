//
//  DotPageCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 30.06.2022.
//

import Foundation
import UIKit

class DotPageCellView: CustomXibCollectionViewCell {
    
    @IBOutlet weak var dotImageView: UIImageView!
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .clear
        self.view.backgroundColor = .clear
    }
    
}
