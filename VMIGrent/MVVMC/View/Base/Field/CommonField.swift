//
//  CommonField.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 29.05.2022.
//

import Foundation
import UIKit

enum CommonFieldType {
    case simple
    case date
    case email
    case search
}

class CommonField: UITextField {
    
    var type: CommonFieldType = .simple {
        didSet {
            self.setLeftPaddingPoints(15)
            self.rightView = nil
            switch self.type {
            case .simple:
                self.setSimple()
            case .date:
                self.setDate()
            case .email:
                self.setEmail()
            case .search:
                self.setSearch()
            }
        }
    }
    
    var action: ((String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? Colors.white : Colors.white.withAlphaComponent(0.3)
            self.textColor = isEnabled ? Colors.mainBlack : Colors.mainBlack.withAlphaComponent(0.5)
        }
    }
    
    private func setupUI() {
        self.autocapitalizationType = .sentences
        self.borderStyle = .none
        self.backgroundColor = Colors.white
        self.layer.borderColor = Colors.e3e3e3.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.textColor = Colors.mainBlack
        self.font = Fonts.regular(size: 16)
        self.addTarget(self, action: #selector(self.fieldDidChange), for: .editingChanged)
        self.setLeftPaddingPoints(15)
        self.setRightPaddingPoints(15)
        self.addReadyButton()
    }
    
    @objc func fieldDidChange() {
        self.action?(self.text ?? "")
    }
    
    private func setEmail() {
        self.keyboardType = .emailAddress
    }
    
    private func setSearch() {
        let search = UIImageView(image: UIImage(named: "search")!)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 24 + 24, height: 24))
        if let size = search.image?.size {
            search.frame = CGRect(x: 0, y: 0.0, width: 24, height: size.height)
        }
        search.contentMode = UIView.ContentMode.right
        search.center = view.center
        view.addSubview(search)
        self.leftView = view
        self.leftViewMode = UITextField.ViewMode.always
    }
    
    private func setDate() {
        let arrow = UIImageView(image: UIImage(named: "calendar")!)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 24 + 30, height: 24))
        if let size = arrow.image?.size {
            arrow.frame = CGRect(x: 0, y: 0.0, width: 40, height: size.height)
        }
        arrow.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.rightViewTapped))
        arrow.addGestureRecognizer(tap)
        arrow.contentMode = UIView.ContentMode.left
        arrow.center = view.center
        view.addSubview(arrow)
        self.rightView = view
        self.rightViewMode = UITextField.ViewMode.always
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        }
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        datePicker.date = DateFormatter.yyyyMMdd.date(from: self.text ?? "") ?? Date()
        self.inputView = datePicker
    }
                             
     @objc func dateChanged(_ sender: UIDatePicker) {
         let date = DateFormatter.yyyyMMdd.string(from: sender.date)
         self.text = date
         self.action?(date)
     }
    
    private func setSimple() {
        
    }
    
    @objc func rightViewTapped() {
        self.becomeFirstResponder()
    }
    
}
