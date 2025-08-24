//
//  EmptyView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 29.06.2022.
//

import Foundation
import UIKit

enum EmptyViewType: Int {
    case favorite = 0
    case book
    
    var image: UIImage {
        switch self {
        case .favorite:
            return UIImage(named: "favorite_empty")!
        case .book:
            return UIImage(named: "book_empty")!
        }
    }
    
    var title: String {
        switch self {
        case .favorite:
            return "У вас пока нет\nизбранных объектов"
        case .book:
            return "У вас пока нет\nбронирований"
        }
    }
    
    var descr: String {
        switch self {
        case .favorite:
            return "Отмечайте объекты размещения, которые вам понравились, сердечком - они будут храниться здесь"
        case .book:
            return "Здесь будет храниться информация об активном бронировании и о тех, что уже завершены"
        }
    }
}

class EmptyView: CustomXibView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    
    @IBInspectable
    var type: Int = 0 {
        didSet {
            let type = EmptyViewType(rawValue: self.type) ?? .book
            self.setupType(type)
            self.setNeedsDisplay()
        }
    }
    
    func setupType(_ type: EmptyViewType) {
        self.imageView.image = type.image
        self.titleLabel.text = type.title
        self.descrLabel.text = type.descr
    }
    
}
