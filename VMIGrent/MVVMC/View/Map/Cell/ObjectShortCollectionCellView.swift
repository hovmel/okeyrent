//
//  ObjectShortCollectionCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 08.07.2022.
//

import Foundation
import UIKit

class ObjectShortCollectionCellView: CustomXibCollectionViewCell {
    
    @IBOutlet weak var objectShortView: ObjectShortView!
    
    var action: (() -> ())?
    var favoriteAction: (() -> ())?
    
    override func setupViews() {
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.view.backgroundColor = .clear
        self.objectShortView.favoriteAction = { [unowned self] in
            self.favoriteAction?()
        }
        self.objectShortView.action = { [unowned self] in
            self.action?()
        }
    }
    
    func setupModel(_ model: ObjectModel) {
        self.objectShortView.setupModel(model)
    }
    
    func setupModel(_ model: ObjectShortModel) {
        self.objectShortView.setupModel(model)
    }
    
}
