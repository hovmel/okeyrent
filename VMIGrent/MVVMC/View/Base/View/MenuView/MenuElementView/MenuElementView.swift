//
//  MenuElementView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 07.06.2022.
//

import Foundation
import UIKit

enum MenuElement: Int, CaseIterable {
    case search = 0
    case favorite = 1
    case book = 2
    case profile = 3
    
    var title: String {
        switch self {
        case .search:
            return "Поиск"
        case .favorite:
            return "Избранное"
        case .book:
            return "Бронирования"
        case .profile:
            return "Профиль"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .search:
            return UIImage(named: "menu_search")!
        case .favorite:
            return UIImage(named: "menu_favorite")!
        case .book:
            return UIImage(named: "menu_book")!
        case .profile:
            return UIImage(named: "menu_profile")!
        }
    }
}

class MenuElementView: CustomXibView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var menuElement: MenuElement = .search {
        didSet {
            self.titleLabel.text = self.menuElement.title
            self.iconImageView.image = self.menuElement.icon
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            self.setupSelected()
        }
    }
    
    override func setupViews() {
        self.backgroundColor = .clear
        self.view.backgroundColor = .clear
    }
    
    func setupSelected() {
        self.titleLabel.textColor = self.isSelected ? Colors.main : Colors.white
        self.iconImageView.tintColor = self.isSelected ? Colors.main : Colors.white
    }
    
}
