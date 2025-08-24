//
//  TimeController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.07.2022.
//

import Foundation
import UIKit

fileprivate let bottom_start_space: CGFloat = 400.0

enum TimeControllerType {
    case time
    case date
}

class TimeController: UIViewController {
    
    @IBOutlet weak var bottomConstr: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var continueButton: VmigButton!
    
    var action: ((Date) -> ())?
    
    var maxDate: Date?
    var minDate: Date?
    var value: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        if let value = value {
            self.datePicker.setDate(value, animated: false)
        }
        self.datePicker.minimumDate = self.minDate
        self.datePicker.maximumDate = self.maxDate
        self.datePicker.date = self.value ?? Date()
        self.view.backgroundColor = .clear
        self.bottomConstr.constant = -bottom_start_space
        self.continueButton.isEnabled = true
        self.continueButton.action = { [unowned self] in
            self.action?(self.datePicker.date)
            self.animateView(false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateView(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.bgView.roundedCorners(top: true)
    }
    
    private func animateView(_ isOpen: Bool) {
        self.bottomConstr.constant = isOpen ? 0 : -bottom_start_space
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.view.backgroundColor = isOpen ? .black.withAlphaComponent(0.6) : .clear
            self.view.layoutSubviews()
        } completion: { _ in
            if !isOpen {
                self.dismiss(animated: false)
            }
        }
    }
    
    @IBAction func closePressed() {
        self.animateView(false)
    }
    
}
