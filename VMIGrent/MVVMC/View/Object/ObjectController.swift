//
//  ObjectController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 30.06.2022.
//

import Foundation
import UIKit
import CoreLocation

enum ObjectSection {
    case header
    case owner
    case descr
    case rules(ObjectRulesCellModel)
    case services([FeatureModel])
    case reviews([ReviewModel], Double)
}

class ObjectController: UIViewController {
    
    class func openObjectController(viewController: UIViewController, id: Int, filterModel: FilterModel? = nil) {
        let storyboard = UIStoryboard(name: "Object", bundle: nil)
        var controllers: [UIViewController] = viewController.navigationController?.viewControllers ?? [viewController]
        let objectController = storyboard.instantiateInitialViewController() as! ObjectController
        objectController.viewModel = ObjectViewModel(view: objectController, id: id, filterModel: filterModel)
        controllers.append(objectController)
        viewController.navigationController?.setViewControllers(controllers, animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoriteButton: FavoriteButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var galleryView: GalleryView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var botView: UIView!
    @IBOutlet weak var vmigButton: VmigButton!
    @IBOutlet weak var priceView: PriceView!
    @IBOutlet weak var datesButton: UIButton!
    
    var viewModel: ObjectViewModel!
    
    var opendIDs: [Int] = []
    
    var sections: [ObjectSection] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.viewModel.getObject()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.galleryView.roundedCorners(top: false)
        self.botView.roundedCorners(top: true)
    }
    
    private func setupUI() {
//        self.datesLabel.isHidden = self.viewModel.filterModel?.dateStr == nil
        self.title = ""
        self.datesButton.setTitle(self.viewModel.filterModel?.dateStr, for: .normal)
        self.checkActionEnabled()
        self.favoriteButton.makeShadow()
        self.backButton.makeShadow()
        self.view.backgroundColor = Colors.f2f2f2
        self.botView.backgroundColor = Colors.f2f2f2
        self.commonSetup()
        self.tableView.separatorStyle = .singleLine
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        self.commonTableViewSetup(tableView: self.tableView, cells: [ObjectSummaryCellView.self,
                                                                     OwnerCellView.self,
                                                                     ObjectDescriptionCellView.self,
                                                                     ObjectFeaturesCellView.self,
                                                                     ObjectRulesCellView.self,
                                                                     ObjectReviewsCollectionView.self,
                                                                     ObjectInfoCellView.self])
        self.galleryView.clipsToBounds = true
        self.botView.makeCenterShadow()
        self.botView.backgroundColor = Colors.f2f2f2
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = Colors.f2f2f2
        self.view.isUserInteractionEnabled = true
        self.vmigButton.action = {
            guard AuthManager.shared.authComplete() else {
                self.showAuthAlert()
                return
            }
            guard let object = self.viewModel.object else {return}
            self.viewModel.filterModel?.startTime = DateFormatter.hoursAndMnutes.date(from: object.checkInTimeStart!) ?? Date()
            self.viewModel.filterModel?.endTime = DateFormatter.hoursAndMnutes.date(from: object.checkOutTimeEnd!) ?? Date()
            BookingController.openBookingController(viewController: self, object: object, filterModel: self.viewModel.filterModel!)
        }
    }
    
    func checkActionEnabled() {
        self.vmigButton.isEnabled = self.viewModel.filterModel?.startDate != nil && self.viewModel.filterModel?.endDate != nil
    }
    
    @IBAction func favoritePressed() {
        self.viewModel.favoriteEvent()
    }
    
    @IBAction func backPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePressed() {
        self.openCalendar(startDate: self.viewModel.filterModel?.startDate,
                          endDate: self.viewModel.filterModel?.endDate) { [unowned self] minDate, maxDate in
            self.viewModel.filterModel?.startDate = minDate
            self.viewModel.filterModel?.endDate = maxDate
            self.datesButton.setTitle(self.viewModel.filterModel?.dateStr, for: .normal)
            self.checkActionEnabled()
        }
    }
    
}

extension ObjectController: ObjectView {
    
    func error(_ message: String) {
        self.openErrorAlert(message: message)
    }
    
    func showAuthAlert() {
        self.presentAuthAlert()
    }
    
    func setupFavoriteLoading(_ isLoading: Bool) {
        self.favoriteButton.setupLoading(isLoading)
    }
    
    func setupLoading(_ isLoading: Bool) {
        isLoading ? self.loader.startAnimating() : self.loader.stopAnimating()
    }
    
    func setObject(_ object: ObjectModel, reviews: [ReviewModel]) {
        let objectImages = object.pictures?.map({ImageCellViewModel(image: $0.picture?.original)}) ?? []
        self.galleryView.images = objectImages
        self.galleryView.action = { [unowned self] in
            guard objectImages.count > 0 else {return}
            if let topVC = UIApplication.shared.topMostViewController() {
                topVC.openImageZoomController(images: objectImages.compactMap({$0.image}), index: self.galleryView.pageControl.currentPage)
            }
        }
        let rulesModel = ObjectRulesCellModel(startFromTime: object.checkInTimeStart,
                                              startToTime: object.checkInTimeEnd,
                                              endTime: object.checkOutTimeEnd,
                                              descr: object.checkInType?.description ?? "")
        self.sections = [.header, .owner]
        if object.description != nil && object.description != "" {
            self.sections.append(.descr)
        }
        if !rulesModel.isEmpty {
            self.sections.append(.rules(rulesModel))
        }
        if (!(object.features?.isEmpty ?? true)) {
            self.sections.append(.services(object.features ?? []))
        }
        if !reviews.isEmpty {
            self.sections.append(.reviews(reviews, self.viewModel.object?.rate ?? 0.0))
        }
        self.priceView.setupPrice(object.priceDay ?? 0)
        self.favoriteButton.isSelected = object.inFavorite ?? false
        self.tableView.reloadData()
    }
    
}

extension ObjectController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.sections[indexPath.row] {
        case .header:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ObjectSummaryCellView.self), for: indexPath) as? ObjectSummaryCellView {
                cell.setupModel(self.viewModel.object!)
                cell.mapAction = { [unowned self] in
                    MapController.openMapController(viewController: self,
                                                    city: self.viewModel.object!.city!,
                                                    object: self.viewModel.object!)
                }
                return cell
            }
        case .owner:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OwnerCellView.self), for: indexPath) as? OwnerCellView {
                cell.setupModel(self.viewModel.object!)
                return cell
            }
        case .descr:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ObjectInfoCellView.self), for: indexPath) as? ObjectInfoCellView {
                cell.setupText(self.viewModel.object?.description ?? "")
                return cell
            }
        case .services(let features):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ObjectFeaturesCellView.self), for: indexPath) as? ObjectFeaturesCellView {
                cell.setModels(features)
                return cell
            }
        case .rules(let model):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ObjectRulesCellView.self), for: indexPath) as? ObjectRulesCellView {
                cell.setupModel(model)
                return cell
            }
        case .reviews(let reviews, let rate):
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ObjectReviewsCollectionView.self), for: indexPath) as? ObjectReviewsCollectionView {
                cell.setModels(reviews, rate: rate, opendIDs: self.opendIDs)
                cell.action = { [unowned self] id in
                    if let index = self.opendIDs.firstIndex(where: {$0 == id}) {
                        self.opendIDs.remove(at: index)
                    } else {
                        self.opendIDs.append(id)
                    }
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
}
