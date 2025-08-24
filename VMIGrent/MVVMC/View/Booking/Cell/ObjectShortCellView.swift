//
//  ObjectShortCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.07.2022.
//

import Foundation
import UIKit

fileprivate let top_big_const: CGFloat = 16.0
fileprivate let bot_big_const: CGFloat = 16.0
fileprivate let top_small_const: CGFloat = 8.0
fileprivate let bot_small_const: CGFloat = 8.0

class ObjectShortCellView: UITableViewCell {
    
    @IBOutlet weak var topConstr: NSLayoutConstraint!
    @IBOutlet weak var botConstr: NSLayoutConstraint!
    @IBOutlet weak var objectShortView: ObjectShortView!
    
    var action: (() -> ())?
    
    var isBigPadding: Bool = true {
        didSet {
            self.topConstr.constant = self.isBigPadding ? top_big_const : top_small_const
            self.botConstr.constant = self.isBigPadding ? bot_big_const : bot_small_const
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    func setupCell() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.f2f2f2
        self.objectShortView.action = { [unowned self] in
            self.action?()
        }
    }
    
    func setupModel(_ model: ObjectModel, isFavorite: Bool = true) {
        self.objectShortView.setupModel(model)
        self.objectShortView.favoriteButton.isHidden = !isFavorite
    }
    
    func setupModel(_ model: ObjectShortModel, isFavorite: Bool = true) {
        self.objectShortView.setupModel(model)
        self.objectShortView.favoriteButton.isHidden = !isFavorite
    }
    
}
