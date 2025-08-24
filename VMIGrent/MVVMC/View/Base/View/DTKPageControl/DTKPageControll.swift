//
//  DTKPageControll.swift
//  GoldenSim
//
//  Created by Mikhail Koroteev on 22.03.2022.
//

import Foundation
import UIKit

class DTKPageControll: CustomXibView {

    @IBInspectable var currentPageImage: UIImage?
    @IBInspectable var otherPagesImage: UIImage?
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewWidthConstr: NSLayoutConstraint!
    
    var numberOfPages: Int = 3 {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var currentPage: Int = 0 {
        didSet {
            let otherPagesSize = 3 * (self.numberOfPages-1)
            let spacingSize = 2 * (self.numberOfPages-1)
            let currentPageSize = 8
            self.collectionViewWidthConstr.constant = CGFloat(otherPagesSize + spacingSize + currentPageSize)
            self.layoutSubviews()
            self.collectionView.reloadData()
        }
    }
    
    func setupPages() {
//        self.pages.forEach({$0.image = otherPagesImage})
//        self.pages[self.currentPage].image = currentPageImage
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupPages()
        self.backgroundColor = .clear
        self.view.backgroundColor = .clear
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(DotPageCellView.self, forCellWithReuseIdentifier: String(describing: DotPageCellView.self))
    }

}

extension DTKPageControll: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DotPageCellView.self), for: indexPath) as? DotPageCellView {
            cell.dotImageView.image = indexPath.row == self.currentPage ? currentPageImage : otherPagesImage
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: indexPath.row == self.currentPage ? 8.0 : 3.0, height: 3.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}
