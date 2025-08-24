//
//  SelectionView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 16.06.2022.
//

import Foundation
import UIKit

class SelectionView: CustomXibView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    var action: (() -> ())?
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .clear
        self.view.layer.cornerRadius = 20
        self.view.backgroundColor = Colors.white
        self.view.layer.borderWidth = 1
        self.view.layer.borderColor = Colors.e3e3e3.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewDidTapped))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    func setupView(text: String, image: UIImage) {
        self.imageView.image = image
        self.textLabel.text = text
    }
    
    @objc private func viewDidTapped() {
        self.action?()
    }
    
}
