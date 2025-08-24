//
//  MenuView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 07.06.2022.
//

import Foundation
import UIKit

class MenuView: CustomXibView {
    
    @IBOutlet var elements: [MenuElementView]!
    
    var action: ((MenuElement) -> ())?
    
    @IBAction func menuElementPressed(_ sender: UIButton) {
        self.action?(self.elements[sender.tag].menuElement)
    }
    
    func setSelected(index: Int) {
        self.elements.forEach({$0.isSelected = false})
        self.elements[index].isSelected = true
    }
    
    override func setupViews() {
        super.setupViews()
        for (index, menuElement) in MenuElement.allCases.enumerated() {
            self.elements[index].menuElement = menuElement
        }
        self.elements.forEach({$0.isSelected = false})
        self.elements[0].isSelected = true
        self.view.backgroundColor = Colors.mainBlack
        self.view.layer.cornerRadius = 20
        self.backgroundColor = .clear
    }
    
}
