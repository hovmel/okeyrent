//
//  ImageZoomView.swift
//  Tele2Sim
//
//  Created by Mikhail Koroteev on 12.05.2020.
//  Copyright © 2020 mskMobile. All rights reserved.
//

import UIKit

class ImageZoomController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var images: [String]!
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.view.backgroundColor = .black
    }
    
    private func setupUI() {
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(ImageZoomCellView.self,
                                     forCellWithReuseIdentifier: String(describing: ImageZoomCellView.self))
        self.collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let index = index, self.images.count > index {
            self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredVertically, animated: false)
            self.index = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
//    private func addSwipeGesture() {
//        let swipeGesture = UISwi
//    }
    
    @IBAction func close() {
//        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
//            self.view.alpha = 0
//            }, completion: { [weak self] success in
//                guard let self = self else {return}
                self.dismiss(animated: true, completion: nil)
//        })
    }
    
}

extension ImageZoomController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageZoomCellView.self),
                                                         for: indexPath) as? ImageZoomCellView {
            cell.createImageScrollView(frame: UIScreen.main.bounds, image: self.images[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width,
                      height: UIScreen.main.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
