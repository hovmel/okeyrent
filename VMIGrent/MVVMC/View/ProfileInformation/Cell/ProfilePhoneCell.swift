//
//  ProfilePhoneCell.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 25.06.2022.
//

import UIKit

class ProfilePhoneCell: UITableViewCell {

    @IBOutlet weak var phoneLabel: UILabel!
    
    var changeAction: (() -> ())?
    
    func setupPhone(_ phone: String) {
        self.phoneLabel.text = phone
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = UITableViewCell.SelectionStyle.none
        self.backgroundColor = Colors.f2f2f2
    }
    
    @IBAction func changePressed() {
        self.changeAction?()
    }
    
}
