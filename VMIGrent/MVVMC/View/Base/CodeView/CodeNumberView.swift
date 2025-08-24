//
//  CodeNumberView.swift
//  services
//
//  Created by Daniil Alferov on 25/08/2018.
//  Copyright © 2018 Duotek. All rights reserved.
//

import UIKit
import SnapKit

protocol CodeNumberViewDelegate: AnyObject {
    func didEnterAllDigits(_ codeString: String, confirmationView: CodeNumberView)
}

@IBDesignable
class CodeNumberView: UIView {

    weak var delegate: CodeNumberViewDelegate!
    
    var blocksArray = [ConfirmationCodeBlock]()
    var tmpTextField: UITextField!
    
    var numberOfBlocks: Int = 4 {
        didSet {
            configureView()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configureView()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    func reloadBlockView(_ text: String!) {
        if let str = text {
            let chars = Array(str).map({ String($0) })
            for index in 0..<blocksArray.count {
                if index < chars.count {
                    blocksArray[index].setNumber(chars[index])
                    blocksArray[index].alpha = 1.0
                } else {
                    blocksArray[index].alpha = 1
                    blocksArray[index].setNumber(nil)
                }
            }
        } else {
            for block in blocksArray {
                block.alpha = 1
                block.setNumber(nil)
            }
        }
    }
    /*
    override var canResignFirstResponder: Bool {
        return false
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    */
    private func configureView() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        blocksArray.removeAll()
        tmpTextField = nil
        tmpTextField = UITextField(frame: .zero)
        tmpTextField.keyboardType = .numberPad
        tmpTextField.delegate = self
        if #available(iOS 12.0, *) {
            tmpTextField.textContentType = UITextContentType.oneTimeCode
        }
        tmpTextField.isHidden = true
        addSubview(tmpTextField)
        
        backgroundColor = .clear
        
        let mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 12.0
        
        let leftStackView = UIStackView()
        leftStackView.axis = .horizontal
        leftStackView.distribution = .fillEqually
        leftStackView.spacing = 4.0
        
        let rightStackView = UIStackView()
        rightStackView.axis = .horizontal
        rightStackView.distribution = .fillEqually
        rightStackView.spacing = 4.0
        
        mainStackView.addArrangedSubview(leftStackView)
        mainStackView.addArrangedSubview(rightStackView)
        
        self.addViews(leftStackView)
        self.addViews(rightStackView)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
        mainStackView.isUserInteractionEnabled = true
        mainStackView.addGestureRecognizer(gestureRecognizer)
        addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(0)
            make.top.equalTo(self)
            make.trailing.equalTo(self).offset(0)
            make.bottom.equalTo(self)
        }
//        tmpTextField.becomeFirstResponder()
    }
    
    func addViews(_ stackView: UIStackView) {
        for _ in 0..<self.numberOfBlocks/2 {
            let width = (UIScreen.main.bounds.width - 30 - 12 - 16)/6
            let view = ConfirmationCodeBlock(frame: CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: width))
            view.snp.makeConstraints { (make) in
                make.width.equalTo(width).priority(999)
            }
            stackView.addArrangedSubview(view)
            view.alpha = 1
            blocksArray.append(view)
        }
    }
    
    @objc private func showKeyboard() {
        if !(tmpTextField.isFirstResponder) {
            tmpTextField.becomeFirstResponder()
        }
    }
    /*
    override var inputViewController: UIInputViewController? {
        return inputController
    }
*/
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension CodeNumberView: UITextFieldDelegate, CAAnimationDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        guard let text = textField.text else {
            reloadBlockView(nil)
            return true
        }
        if (isBackSpace == -92) {
            reloadBlockView(String(text.dropLast()))
        } else {
            if text.count + 1 > numberOfBlocks {
                return false
            }
            
            reloadBlockView(text + string)
            
            if text.count + 1 == numberOfBlocks {
                delegate?.didEnterAllDigits(text + string, confirmationView: self)
            }
        }
        //print("dsfdsaf")
        return true
    }
    
    func incorrectCode() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.delegate = self
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            tmpTextField.text = nil
            reloadBlockView(nil)
            showKeyboard()
        }
    }
    
}

class ConfirmationCodeBlock: UIView {
    
    var numberLabel: UILabel = UILabel()
    
    func setNumber(_ number: String!) {
        if let number = number {
            numberLabel.text = number
            numberLabel.isHidden = false
        } else {
            numberLabel.text = nil
            numberLabel.isHidden = true
        }
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configureView()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    private func configureView() {
        
        self.backgroundColor = Colors.white
        self.layer.borderColor = Colors.e3e3e3.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        self.clipsToBounds = true

        numberLabel.frame = frame
        numberLabel.backgroundColor = .clear
        numberLabel.font = Fonts.regular(size: 16)
        numberLabel.textColor = Colors.mainBlack
        numberLabel.textAlignment = .center
        
        addSubview(numberLabel)
        
        numberLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self)
            make.top.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
    
}
