//
//  GalleryView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 30.06.2022.
//

import Foundation
import UIKit

class GalleryView: CustomXibView {
    
    @IBOutlet weak var pageControl: DTKPageControll!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var action: (() -> ())?
    
    var images: [ImageCellViewModel] = [] {
        didSet {
            if self.images.isEmpty {
                self.images = [ImageCellViewModel(image: nil)]
            }
            self.pageControl.numberOfPages = images.count
            self.collectionView.reloadData()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .clear
        self.view.backgroundColor = .clear
//        self.layer.borderWidth = 1
//        self.layer.borderColor = Colors.e3e3e3.cgColor
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(ImageCellView.self, forCellWithReuseIdentifier: String(describing: ImageCellView.self))
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imagePressed))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    @objc func imagePressed() {
        self.action?()
    }
    
}

extension GalleryView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.images[indexPath.row]
        return collectionView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
    
}
