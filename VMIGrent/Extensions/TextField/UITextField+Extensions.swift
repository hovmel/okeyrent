//
//  UITextField+Extensions.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 01.06.2022.
//

import Foundation
import UIKit

extension UITextField {

    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func addReadyButton() {
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(self.dismissSelector))
        doneBtn.tintColor = Colors.mainBlack
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    
    @objc func dismissSelector() {
        if let controller = UIApplication.shared.topMostViewController() {
            controller.view.endEditing(true)
        }
    }

}
