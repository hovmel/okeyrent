//
//  UITextView+extensions.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 22.07.2022.
//

import Foundation
import UIKit

extension UITextView {
    
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
