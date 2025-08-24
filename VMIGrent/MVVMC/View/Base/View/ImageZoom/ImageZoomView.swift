//
//  ImageZoomView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 11.08.2022.
//

import Foundation
import UIKit
import Kingfisher

class ImageZoomScrollView: UIScrollView, UIScrollViewDelegate {
    
    var imageView: UIImageView!
    
    var gestureRecognizer: UITapGestureRecognizer!

    convenience init(frame: CGRect, image: UIImage) {
        self.init(frame: frame)

        // Creates the image view and adds it as a subview to the scroll view
        imageView = UIImageView(image: image)
        imageView.frame = frame
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        setupScrollView()
        setupGestureRecognizer()
    }
    
    convenience init(frame: CGRect, image: String) {
        self.init(frame: frame)

        // Creates the image view and adds it as a subview to the scroll view
        imageView = UIImageView()
        imageView.kf.indicatorType = .activity
        if let url = URL(string: image) {
            imageView.kf.setImage(with: url)
        }
        imageView.frame = frame
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        setupScrollView()
        setupGestureRecognizer()
    }
    
    func updateView(frame: CGRect, image: String) {
        imageView.kf.indicatorType = .activity
        imageView.image = nil
        if let url = URL(string: image) {
            imageView.kf.setImage(with: url)
        }
    }
    
    func setupGestureRecognizer() {
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        gestureRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleDoubleTap() {
        if zoomScale == 1 {
            zoom(to: zoomRectForScale(maximumZoomScale, center: gestureRecognizer.location(in: gestureRecognizer.view)), animated: true)
        } else {
            setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let newCenter = convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func setupScrollView() {
        minimumZoomScale = 1.0
        maximumZoomScale = 2.0
        delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
