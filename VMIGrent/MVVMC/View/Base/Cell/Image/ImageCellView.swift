//
//  ImageCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 30.06.2022.
//

import Foundation
import UIKit
import Kingfisher

class ImageCellView: CustomXibCollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .clear
        self.view.backgroundColor = .clear
    }
    
    func setupImage(_ image: String?) {
        self.imageView.image = nil
        if let image = image, let url = URL(string: image) {
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: url)
        } else {
            self.imageView.image = UIImage(named: "template_object")!
        }
    }
    
}

struct ImageCellViewModel: CellViewModel {
    let image: String?
}

extension ImageCellViewModel {
    func setup(cell: ImageCellView) {
        cell.setupImage(self.image)
    }
    
}
