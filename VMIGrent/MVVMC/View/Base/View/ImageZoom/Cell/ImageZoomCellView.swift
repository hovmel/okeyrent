//
//  ImageZoomCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 11.08.2022.
//

import Foundation
import UIKit
import Kingfisher

class ImageZoomCellView: CustomXibCollectionViewCell {
    
    var imageZoomScrollView: ImageZoomScrollView?

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setupViews() {
        super.setupViews()
        self.view.backgroundColor = .black
    }

    func createImageScrollView(frame: CGRect, image: String) {
        if self.imageZoomScrollView == nil {
            self.imageZoomScrollView = ImageZoomScrollView(frame: frame, image: image)
            self.view.addSubview(imageZoomScrollView!)
        } else {
            self.imageZoomScrollView!.updateView(frame: frame, image: image)
        }
    }
    
}
