//
//  ListCellView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 20.06.2022.
//

import Foundation
import UIKit

class ListCellView: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    
    var models: [ListCellModel] = [] {
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
    
    func setModels(_ models: [ListCellModel], title: String, isStar: Bool) {
        self.models = models
        self.titleLabel.text = title
        self.starImageView.isHidden = !isStar
    }
    
    private func setupCell() {
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(CityCellView.self,
                                     forCellWithReuseIdentifier: String(describing: CityCellView.self))
    }
    
}
extension ListCellView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CityCellView.self),
                                                         for: indexPath) as? CityCellView {
            cell.setupModel(self.models[indexPath.row])
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
        return CGSize(width: 180,
                      height: 239)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
}
