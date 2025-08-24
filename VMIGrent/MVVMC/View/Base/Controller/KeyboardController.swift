//
//  KeyboardController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 05.06.2022.
//

import UIKit

class KeyboardController: UIViewController {
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideTap()
    }
    
    func hideTap() {
        let hideKeyBoardTap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyBoardWhenTappedAround(tap:)))
        hideKeyBoardTap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(hideKeyBoardTap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // KEYBOARD
    
    @objc private func hideKeyBoardWhenTappedAround(tap: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            var keyboardHeight = keyboardRectangle.height
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.keyWindow
                let bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
                keyboardHeight -= bottomPadding
            }
            self.changeKeyboardHeight(keyboardHeight)
            UIView.animate(withDuration: 0.5) {
                self.setKeyboardHide(false)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: Notification) {
        if (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) != nil {
            self.changeKeyboardHeight(0.0)
            UIView.animate(withDuration: 0.5) {
                self.setKeyboardHide(true)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func changeKeyboardHeight(_ keyboardHeight: CGFloat) {}
    
    func setKeyboardHide(_ isHide: Bool) {}
    
}
