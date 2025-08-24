//
//  DocumentView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 26.06.2022.
//

import Foundation
import UIKit

enum DocumentViewType {
    case passport
    case selfie
    
    var size: CGSize {
        switch self {
        case .passport:
            return CGSize(width: 58, height: 80)
        case .selfie:
            return CGSize(width: 90, height: 74)
        }
    }
    
    var image: UIImage {
        switch self {
        case .passport:
            return UIImage(named: "doc_docs")!
        case .selfie:
            return UIImage(named: "doc_selfie")!
        }
    }
    
    var title: String {
        switch self {
        case .passport:
            return "Фото первого разворота паспорта\n(с фотографией)"
        case .selfie:
            return "Селфи с раскрытым первым разворотом паспорта"
        }
    }
    
    var cameraTitle: String {
        switch self {
        case .passport:
            return "Фото паспорта"
        case .selfie:
            return "Селфи с паспортом"
        }
    }
    
    var cameraDescr: String {
        switch self {
        case .passport:
            return "Поместите первый разворот паспорта в рамку и сделайте фотографию"
        case .selfie:
            return "Сделайте селфи с раскрытым первым разворотом паспорта. Мы сравним снимок с фото в удостоверении личности"
        }
    }
    
    var photoTitle: String {
        switch self {
        case .passport:
            return "Фото чёткое?"
        case .selfie:
            return "Фото чёткое?"
        }
    }
    
    var photoDescr: String {
        switch self {
        case .passport:
            return "Снимок должен быть четким, светлым и без бликов"
        case .selfie:
            return "Снимок должен быть четким, светлым и без бликов"
        }
    }
}

class DocumentView: CustomXibView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidthContr: NSLayoutConstraint!
    
    var action: (() -> ())?
    
    var type: DocumentViewType = .passport {
        didSet {
            self.titleLabel.text = type.title
            self.iconImageView.image = type.image
            self.imageViewHeightConstr.constant = type.size.height
            self.imageViewWidthContr.constant = type.size.width
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.view.addLineDashedStroke(pattern: [2, 2], radius: 20, color: Colors.gray.withAlphaComponent(0.5).cgColor)
    }
    
    @objc func didSelectView() {
        self.action?()
    }
    
    override func setupViews() {
        super.setupViews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didSelectView))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = 20
        self.view.backgroundColor = .white
        self.view.layer.cornerRadius = 20
        self.view.clipsToBounds = true
    }
    
}
