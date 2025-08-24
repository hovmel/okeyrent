//
//  VmigButton.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 28.06.2022.
//

import Foundation
import UIKit

class VmigButton: CustomXibView {
    
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textStackView: UIStackView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var action: (() -> ())?
    
    @IBInspectable
    var isBordered: Bool = false {
        didSet {
            self.setupUI()
        }
    }
    
    @IBInspectable
    var image: String? = "next_arrow" {
        didSet {
            if let image = image {
                self.arrowImageView.image = UIImage(named: image) ?? UIImage(named: "next_arrow")!
            } else {
                self.arrowImageView.image = nil
            }
        }
    }
    
    var isEnabled: Bool = false {
        didSet {
            self.setEnabled()
        }
    }
    
    @IBInspectable
    var title: String = "Искать" {
        didSet {
            self.searchLabel.text = title
        }
    }
    
    private func setEnabled() {
        self.setupUI()
    }
    
    func setupLoading(_ isLoading: Bool) {
        isLoading ? self.loader.startAnimating() : self.loader.stopAnimating()
        self.textStackView.isHidden = isLoading
        self.isUserInteractionEnabled = !isLoading
    }
    
    func setupUI() {
        if self.isBordered {
            self.view.backgroundColor = Colors.f2f2f2
            self.searchLabel.textColor = Colors.mainBlack
            self.arrowImageView.tintColor = Colors.mainBlack
            self.layer.borderColor = Colors.mainBlack.withAlphaComponent(0.2).cgColor
            self.layer.borderWidth = 1
        } else {
            self.searchLabel.textColor = self.isEnabled ? Colors.white : Colors.gray
            self.dateLabel.isHidden = !self.isEnabled
            self.dateLabel.textColor = Colors.ABABAB
            self.arrowImageView.tintColor = self.isEnabled ? Colors.white : Colors.ABABAB
            self.view.backgroundColor = self.isEnabled ? Colors.mainBlack : Colors.DDDDDD
        }
    }
    
    override func setupViews() {
        super.setupViews()
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.backgroundColor = .clear
        self.setEnabled()
        self.searchLabel.text = title
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewDidPressed))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    @objc func viewDidPressed() {
        if self.isEnabled {
            self.action?()
        }
    }
    
}
