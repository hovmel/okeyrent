//
//  LockStatusView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 01.08.2022.
//

import Foundation
import UIKit

enum LockStatusViewType {
    case opened
    case closed
    
    var title: String {
        switch self {
        case .opened:
            return "Замок открыт!"
        case .closed:
            return "Замок закрыт"
        }
    }
    
    var descr: String? {
        switch self {
        case .opened:
            return "Добро пожаловать и хорошего отдыха"
        case .closed:
            return nil
        }
    }
    
    var image: UIImage? {
        switch self {
        case .opened:
            return UIImage(named: "unlock")!
        case .closed:
            return UIImage(named: "lock")!
        }
    }
}

class LockStatusView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    
    var type: LockStatusViewType = .closed
    
    class func instanceFromNib(type: LockStatusViewType) -> LockStatusView {
        let statusView = UINib(nibName: "LockStatusView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LockStatusView
        statusView.type = type
        statusView.commonInit()
        return statusView
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func commonInit() {
        self.setupUI()
        self.openView()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupUI() {
        self.alpha = 0
        self.backgroundColor = .black.withAlphaComponent(0.6)
        self.imageView.image = self.type.image
        self.titleLabel.text = self.type.title
        self.descrLabel.text = self.type.descr
    }
    
    @objc func openView() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        } completion: { _ in
            self.perform(#selector(self.closeView), with: nil, afterDelay: 1.0)
        }
    }
    
    @objc func closeView() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
}
