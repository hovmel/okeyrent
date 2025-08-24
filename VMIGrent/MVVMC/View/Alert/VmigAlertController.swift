//
//  VmigAlertController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 09.07.2022.
//

import Foundation
import UIKit

class VmigAlertController: UIViewController {
    
    @IBOutlet weak var bottomConstr: NSLayoutConstraint!
    @IBOutlet weak var topConstr: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var leftActionButton: CommonButton!
    @IBOutlet weak var rightActionButton: CommonButton!
    
    var model: VmigAlertModel!
    
    var leftAction: (() -> ())?
    var rightAction: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .clear
        self.bottomConstr.constant = UIScreen.main.bounds.height
        self.topConstr.constant = UIScreen.main.bounds.height
        self.leftAction = self.model.leftAction
        self.rightAction = self.model.rightAction
        self.titleLabel.text = self.model.title
        self.descrLabel.text = self.model.descr
        self.descrLabel.isHidden = self.model.descr == nil
        self.leftActionButton.isHidden = self.model.leftTitle == nil
        self.leftActionButton.setTitle(self.model.leftTitle, for: .normal)
        self.rightActionButton.setTitle(self.model.rightTitle ?? "Хорошо", for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateView(true)
        self.bgView.roundedCorners(top: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    private func animateView(_ isOpen: Bool, action: (() -> ())? = nil) {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.bottomConstr.constant = isOpen ? 0 : -UIScreen.main.bounds.height
            self.topConstr.constant = isOpen ? 0 : -UIScreen.main.bounds.height
            self.view.backgroundColor = isOpen ? .black.withAlphaComponent(0.6) : .clear
            self.view.layoutSubviews()
        } completion: { _ in
            if !isOpen {
                self.dismiss(animated: false) {
                    action?()
                }
            }
        }
    }
    
    @IBAction func leftPressed() {
        self.animateView(false, action: self.leftAction)
    }
    
    @IBAction func rightPressed() {
        self.animateView(false, action: self.rightAction)
    }
    
}
