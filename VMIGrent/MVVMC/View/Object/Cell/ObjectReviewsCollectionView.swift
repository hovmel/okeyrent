//
//  ObjectReviewsCollectionView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 20.07.2022.
//

import Foundation
import UIKit

fileprivate let default_cell_height: CGFloat = 108.0
fileprivate let default_cell_text_height: CGFloat = 90.0

class ObjectReviewsCollectionView: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var rateView: RateView!
    @IBOutlet weak var countLabel: UILabel!
    
    var openedIDs: [Int] = []
    
    var models: [ReviewModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var action: ((Int) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = UITableViewCell.SelectionStyle.none
        self.backgroundColor = Colors.f2f2f2
        self.setupCell()
    }
    
    func setModels(_ models: [ReviewModel], rate: Double, opendIDs: [Int]) {
        self.models = models
        self.openedIDs = opendIDs
        self.rateView.rateLabel.text = "\(rate)"
        self.countLabel.text = "(\(models.count))"
        self.calculateHight()
//        var maxHeight: CGFloat = 0
//        for model in models {
//            let height = model.review.getEstimatedHeight(248, font: Fonts.regular(size: 14))
//            if maxHeight < height {
//                maxHeight = height
//            }
//        }
//        self.collectionViewHeightConstr.constant = maxHeight + default_cell_height
    }
    
    func calculateHight() {
        var maxHeight: CGFloat = 0
        for model in models {
            let height = self.getHeightForModel(model)
            if maxHeight < height {
                maxHeight = height
            }
        }
        self.collectionViewHeightConstr.constant = maxHeight
    }
    
    private func setupCell() {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.clipsToBounds = false
        self.collectionView.register(ObjectReviewCellView.self,
                                     forCellWithReuseIdentifier: String(describing: ObjectReviewCellView.self))
        self.collectionView.collectionViewLayout = MainCollectionViewFlowLayout()
    }

    private func getHeightForModel(_ model: ReviewModel) -> CGFloat {
        let isOpened: Bool = self.openedIDs.contains(where: {$0 == model.id})
        let estimatedHeight = model.review?.getEstimatedHeight(248, font: Fonts.regular(size: 15)) ?? 0
        let textHeight = (estimatedHeight > default_cell_text_height) ? (isOpened ? estimatedHeight : default_cell_text_height) : estimatedHeight
        let height = textHeight + default_cell_height
        return height
    }
    
}
extension ObjectReviewsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ObjectReviewCellView.self),
                                                         for: indexPath) as? ObjectReviewCellView {
            let model = self.models[indexPath.row]
            let estimatedHeight = model.review?.getEstimatedHeight(248, font: Fonts.regular(size: 14)) ?? 0
            cell.setupModel(model,
                            isOpened: self.openedIDs.contains(model.id),
                            isButton: (estimatedHeight > default_cell_text_height))
            cell.action = { [unowned self] in
                self.action?(model.id)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.action?(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = self.models[indexPath.row]
        
        
        
        return CGSize(width: 280,
                      height: self.getHeightForModel(model))
    }
    
}

class MainCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        let attr = super.layoutAttributesForElements(in: rect)
        var attributes = [UICollectionViewLayoutAttributes]()
        self.scrollDirection = .horizontal
        for itemAttributes in attr! {
            let itemAttributesCopy = itemAttributes.copy() as! UICollectionViewLayoutAttributes
            // manipulate itemAttributesCopy
            attributes.append(itemAttributesCopy)
        }

        if attributes.count == 1 {

            if let currentAttribute = attributes.first {
                currentAttribute.frame = CGRect(x: self.sectionInset.left, y: currentAttribute.frame.origin.y, width: currentAttribute.frame.size.width, height: currentAttribute.frame.size.height)
            }
        } else {
            var sectionHeight: CGFloat = 0

            attributes.forEach { layoutAttribute in
                guard layoutAttribute.representedElementCategory == .supplementaryView else {
                    return
                }

                if layoutAttribute.representedElementKind == UICollectionView.elementKindSectionHeader {
                    sectionHeight = layoutAttribute.frame.size.height
                }
            }

            attributes.forEach { layoutAttribute in
                guard layoutAttribute.representedElementCategory == .cell else {
                    return
                }

                if layoutAttribute.frame.origin.x == 0 {
                    sectionHeight = max(layoutAttribute.frame.minY, sectionHeight)
                }

                layoutAttribute.frame = CGRect(origin: CGPoint(x: layoutAttribute.frame.origin.x, y: sectionHeight), size: layoutAttribute.frame.size)

            }
        }
        return attributes
    }
}
