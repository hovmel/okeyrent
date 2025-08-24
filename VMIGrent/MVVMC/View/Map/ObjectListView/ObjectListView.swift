//
//  ObjectListView.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 22.06.2022.
//

import Foundation
import UIKit

class ObjectListView: CustomXibView {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var loaders : [UIActivityIndicatorView]!
    
    var showAction: (() -> ())?
    var favoriteAction: ((Int) -> ())?
    var objectAction: ((Int) -> ())?
    var closeAction: (() -> ())?
    var swipeAction: ((CGFloat) -> ())?
    var loadMoreAction: (() -> ())?
    
    var loadingData: Bool = false
    
    var favoriteIDisLoading: Int? {
        didSet {
//            if let id = favoriteIDisLoading, let index = objects.firstIndex(where: {$0.id == id}) {
//                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
//            } else {
//                self.tableView.reloadData()
//            }
            self.tableView.reloadData()
        }
    }
    
    var objects: [ObjectShortModel] = []
    
    override func setupViews() {
        super.setupViews()
        self.loaders.forEach({$0.color = Colors.mainBlack})
        self.view.backgroundColor = Colors.f2f2f2
        self.clipsToBounds = false
        self.layer.cornerRadius = 20
        self.view.layer.cornerRadius = 20
        self.topView.backgroundColor = Colors.mainBlack.withAlphaComponent(0.3)
        self.topView.layer.cornerRadius = 2
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: String(describing: ObjectListCell.self),
                                      bundle: nil),
                                forCellReuseIdentifier: String(describing: ObjectListCell.self))
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = Colors.f2f2f2
        self.tableView.backgroundView?.backgroundColor = Colors.f2f2f2
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        let view = UIView()
        view.backgroundColor = Colors.f2f2f2
        self.tableView.tableFooterView = view
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDetect(_:)))
        swipeGesture.direction = .up
        self.addGestureRecognizer(swipeGesture)
        self.isUserInteractionEnabled = true
    }
    
    @objc func swipeDetect(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .up {
            self.showAction?()
        }
    }
    
    func showList(_ isShow: Bool) {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.tableView.alpha = isShow ? 1 : 0
        }
    }
    
    func setCount(_ count: Int) {
        self.countLabel.text = "\(count) вариантов жилья"
    }
    
    func setObjects(_ objects: [ObjectShortModel]) {
        self.objects = objects
        self.tableView.reloadData()
    }
    
    func setupLoading(_ isLoading: Bool) {
        self.loaders.forEach({isLoading ? $0.startAnimating() : $0.stopAnimating()})
        self.countLabel.isHidden = isLoading
        self.tableView.isHidden = isLoading
    }
    
    func setupMoreLoading(_ isLoading: Bool) {
        
    }
    
}

extension ObjectListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ObjectListCell.self),
                                                    for: indexPath) as? ObjectListCell {
            cell.setupModel(self.objects[indexPath.row], isFavoriteLoading: (favoriteIDisLoading == self.objects[indexPath.row].id))
            cell.favoriteAction = { [unowned self] in
                self.favoriteAction?(self.objects[indexPath.row].id)
            }
            cell.action = { [unowned self] in
                self.objectAction?(self.objects[indexPath.row].id)
            }
            cell.galleryView.action = { [unowned self] in
                self.objectAction?(self.objects[indexPath.row].id)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            self.closeAction?()
        }
        if scrollView.contentOffset.y < -150 {
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = objects.count - 5
        if !loadingData && indexPath.row == lastElement {
//            indicator.startAnimating()
            self.loadMoreAction?()
        }
    }
    
}
