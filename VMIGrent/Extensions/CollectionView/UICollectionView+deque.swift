//
//  UICollectionView+deque.swift
//  Abonent
//
//  Created by Mikhail Koroteev on 20.12.2020.
//

import UIKit

extension UICollectionView {
    
    func dequeueReusableCell(withModel model: CellViewAnyModel, for indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: type(of: model).cellAnyType)
        let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        model.setupAny(cell: cell)
        return cell
    }
    
    func dequeueReusableSupplementaryView(withModel model: CellViewAnyModel, ofKind elementKind: String, for indexPath: IndexPath) -> UICollectionReusableView {
        let identifier = String(describing: type(of: model).cellAnyType)
        let cell = self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath)
        
        model.setupAny(cell: cell)
        return cell
    }
    
}
