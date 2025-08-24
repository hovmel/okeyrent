//
//  FeedbackController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.08.2022.
//

import Foundation
import UIKit

class FeedbackController: UIViewController {
    
    @IBOutlet weak var bottomConstr: NSLayoutConstraint!
    @IBOutlet weak var topConstr: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var vmigrentButton: UIButton!
    @IBOutlet weak var ownerButton: UIButton!
    @IBOutlet weak var topView: UIView!
    
    var vmigrentPhone: String?
    var ownerPhone: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .clear
        self.topView.layer.cornerRadius = 3
        self.topView.backgroundColor = Colors.gray
        self.bottomConstr.constant = UIScreen.main.bounds.height
        self.topConstr.constant = UIScreen.main.bounds.height
        if let vmigrentPhone = vmigrentPhone {
            self.vmigrentButton.setTitle(vmigrentPhone + " (VMIGrent)", for: .normal)
            self.vmigrentButton.isHidden = false
        }
        if let ownerPhone = ownerPhone {
            self.ownerButton.setTitle(ownerPhone + " (Хозяин квартиры)", for: .normal)
            self.ownerButton.isHidden = false
        }
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(_:)))
        swipeGesture.direction = .down
        self.bgView.addGestureRecognizer(swipeGesture)
        self.bgView.isUserInteractionEnabled = true
    }
    
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .down:
            self.animateView(false)
        default:
            return
        }
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
    
    @IBAction func vmigPressed() {
        guard let vmigrentPhone = self.vmigrentPhone,
                let number = URL(string: "tel://" + vmigrentPhone) else { return }
        UIApplication.shared.open(number)
    }
    
    @IBAction func ownerPressed() {
        guard let ownerPhone = self.ownerPhone,
                let number = URL(string: "tel://" + ownerPhone) else { return }
        UIApplication.shared.open(number)
    }
    
}
