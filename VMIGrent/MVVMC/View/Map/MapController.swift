//
//  MapController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 16.06.2022.
//

import Foundation
import UIKit
import YandexMapsMobile
import CoreLocation

fileprivate let show_price_zoom: Float = 10.5
fileprivate let location_button_bottom_map_empty_space: CGFloat = 90.0
fileprivate let location_button_bottom_map_space: CGFloat = 154.0
fileprivate let location_button_bottom_list_space: CGFloat = 100.0
fileprivate let object_list_view_hide_space: CGFloat = -UIScreen.main.bounds.height + 137
fileprivate let object_list_view_full_hide_space: CGFloat = -UIScreen.main.bounds.height - 40

enum MapControllerState {
    case map
    case list
    case emptyMap
}

class MapController: UIViewController, YMKClusterListener {
    
    class func openMapController(viewController: UIViewController, city: CityModel, object: ObjectModel? = nil) {
        let storyboard = UIStoryboard(name: "Map", bundle: nil)
        var controllers: [UIViewController] = viewController.navigationController?.viewControllers ?? [viewController]
        let mapController = storyboard.instantiateInitialViewController() as! MapController
        let viewModel = MapViewModel(view: mapController)
        viewModel.city = city
        mapController.object = object
        mapController.viewModel = viewModel
        controllers.append(mapController)
        viewController.navigationController?.setViewControllers(controllers, animated: true)
    }
    
    @IBOutlet weak var mapView: YMKMapView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var citySelectionView: SelectionView!
    @IBOutlet weak var dateSelectionView: SelectionView!
    @IBOutlet weak var objectListView: ObjectListView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var objectListViewBottomConstr: NSLayoutConstraint!
    @IBOutlet weak var locationButtonBottomConstr: NSLayoutConstraint!
    @IBOutlet weak var objectListViewHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var viewModel: MapViewModel!
    
    var object: ObjectModel?
    
    var dotImage = UIImage(named: "map_dot")!
    var currentZoom: Float = 0
    var placemarks: [YMKPlacemarkMapObject] = []
    var groupedObjects: [PlacemarkModel] = []
    var mapImages: [MapImageModel] = []
    var selectedMapImage: MapImageModel?
    var selectedIDs: Set<Int> = [] {
        didSet {
            if let placemark = self.placemarks.first(where: {($0.userData as? Set<Int>) == oldValue}) {
                placemark.zIndex = 0
                self.updatePlaceMark(placemark: placemark, ids: oldValue)
            }
            if let placemark = self.placemarks.first(where: {($0.userData as? Set<Int>) == selectedIDs}) {
                placemark.zIndex = 1
                self.updatePlaceMark(placemark: placemark, ids: selectedIDs)
            }
        }
    }
    
    var objects: [ObjectShortModel] = [] {
        didSet {
            self.collectionView.reloadData()
            self.collectionView.isHidden = self.objects.isEmpty
        }
    }
    
    var state: MapControllerState = .map {
        didSet {
            self.changeState(self.state)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cameraListener = CameraListner { [weak self] zoom in
            guard let self = self else {return}
            self.currentZoom = zoom
            self.getObjectsMap()
        }
        self.viewModel.viewDidOpen()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: .openMenu, object: nil)
    }
    
    internal class CameraListner: NSObject, YMKMapCameraListener {
        
        var zoom: Float = 0
        
        init(action: @escaping ((Float) -> ())) {
            self.action = action
        }
        
        var action: ((Float) -> ())!
        
        func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateReason: YMKCameraUpdateReason, finished: Bool) {
            self.zoom = cameraPosition.zoom
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.didChangedPos), object: nil)
            self.perform(#selector(self.didChangedPos), with: nil, afterDelay: 0.5)
        }
        
        @objc func didChangedPos() {
            self.action?(self.zoom)
        }
        
    }
    var cameraListener: CameraListner!
    
    func changeState(_ state: MapControllerState) {
        switch state {
        case .map:
            self.objectListViewBottomConstr.constant = object_list_view_hide_space
            self.objectListView.showList(false)
            self.locationButton.setImage(UIImage(named: "location")!, for: .normal)
            self.locationButtonBottomConstr.constant = location_button_bottom_map_space
        case .emptyMap:
            self.objectListViewBottomConstr.constant = object_list_view_full_hide_space
            self.objectListView.showList(false)
            self.locationButton.setImage(UIImage(named: "location")!, for: .normal)
            self.locationButtonBottomConstr.constant = location_button_bottom_map_empty_space
        case .list:
            self.selectedIDs = []
            self.objects = []
            self.objectListViewBottomConstr.constant = -20
            self.objectListView.showList(true)
            self.locationButton.setImage(UIImage(named: "map")!, for: .normal)
            self.locationButtonBottomConstr.constant = location_button_bottom_list_space
            self.viewModel.getObjectList()
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutSubviews()
        }
    }
    
    private func setupUI() {
        self.commonSetup()
        self.setupCollection()
        self.collectionViewFlowLayout.minimumLineSpacing = 8
        self.setupMap()
        self.locationButton.makeCenterShadow()
        self.objectListView.makeCenterShadow()
        self.topView.makeShadow()
        self.objectListViewHeightConstr.constant = UIScreen.main.bounds.height + 40
        self.topView.layer.cornerRadius = 20
        self.objectListView.layer.cornerRadius = 20
        self.objectListViewBottomConstr.constant = object_list_view_full_hide_space
        self.citySelectionView.setupView(text: self.viewModel.city.name, image: UIImage(named: "geo")!)
        self.dateSelectionView.setupView(text: "Выбрать даты", image: UIImage(named: "date")!)
        self.citySelectionView.action = { [unowned self] in
            self.openRegionsController { [unowned self] model in
                self.viewModel.city = model
                self.viewModel.viewDidOpen()
                self.setupCity(name: model.name)
            }
        }
        self.dateSelectionView.action = { [unowned self] in
            self.openCalendar(startDate: self.viewModel.filterModel.startDate,
                              endDate: self.viewModel.filterModel.endDate) { [unowned self] startDate, endDate in
                guard let startDate = startDate, let endDate = endDate else {
                    self.viewModel.filterModel.endDate = nil
                    self.viewModel.filterModel.startDate = nil
                    self.dateSelectionView.setupView(text: "Выбрать даты",
                                                     image: UIImage(named: "date")!)
                    self.getObjectsMap()
                    return
                }
                let df = DateFormatter.yyyyMMdd
                let dfShort = DateFormatter.ddMM
                self.viewModel.filterModel.endDate = endDate
                self.viewModel.filterModel.startDate = startDate
                self.dateSelectionView.setupView(text: "\(dfShort.string(from: startDate))-\(dfShort.string(from: endDate))",
                                                 image: UIImage(named: "date")!)
                self.getObjectsMap()
            }
        }
        self.topView.backgroundColor = Colors.f2f2f2
        self.objectListView.closeAction = { [unowned self] in
            self.state = .map
        }
        self.objectListView.showAction = { [unowned self] in
            self.state = .list
        }
        self.objectListView.objectAction = { [unowned self] id in
            NotificationCenter.default.post(name: .closeMenu, object: nil)
            ObjectController.openObjectController(viewController: self, id: id, filterModel: self.viewModel.filterModel)
        }
        self.objectListView.favoriteAction = { [unowned self] id in
            self.viewModel.favoriteEvent(id)
        }
        self.objectListView.loadMoreAction = { [unowned self] in
            self.viewModel.getMoreObjectList()
        }
    }
    
    private func setupCollection() {
        self.collectionView.clipsToBounds = false
        self.collectionView.backgroundColor = .clear
        self.collectionView.register(ObjectShortCollectionCellView.self,
                                     forCellWithReuseIdentifier: String(describing: ObjectShortCollectionCellView.self))
        
    }
    
    private func setupMap() {
        self.mapView.mapWindow.map.addCameraListener(with: cameraListener)
        self.mapView.mapWindow.map.isRotateGesturesEnabled = false
        self.mapView.mapWindow.map.isTiltGesturesEnabled = false
    }
    
    private func setupMapMarks(_ objects: [MapListItem]) {
        self.placemarks.removeAll()
        self.groupedObjects.removeAll()
        objects.forEach { item in
//            guard !self.groupedObjects.contains(where: {$0.ids.contains(item.id)}) else {return}
            if let index = groupedObjects.firstIndex(where: {$0.ln == item.ln}) {
                groupedObjects[index].lowerPrice = item.p < groupedObjects[index].lowerPrice ? item.p : groupedObjects[index].lowerPrice
                let stringPlacemark = objects.count > 1 ? "\(groupedObjects[index].ids.count) от \(objects.first!.p.price)" : "\(groupedObjects[index].lowerPrice.price)"
                groupedObjects[index].title = stringPlacemark
                groupedObjects[index].ids.insert(item.id)
                self.updateImages(item: groupedObjects[index])
            } else {
                let model = PlacemarkModel(ids: [item.id],
                                           title: item.p.price,
                                           lowerPrice: item.p,
                                           ln: item.ln,
                                           lt: item.lt)
                groupedObjects.append(model)
                self.updateImages(item: model)
            }
        }
        self.createPlaceMarks()
    }
    
    func updateImages(item: PlacemarkModel) {
        if let index = self.mapImages.firstIndex(where: {item.ids.isSubset(of: $0.ids)}) {
            guard self.mapImages[index].ids != item.ids else {return}
            self.mapImages[index].image = self.createMarkImage(ids: item.ids)
            self.mapImages[index].ids = item.ids
        } else {
            self.mapImages.append(MapImageModel(image: self.createMarkImage(ids: item.ids),
                                                ids: item.ids))
        }
    }
    
    func updatePlaceMark(placemark: YMKPlacemarkMapObject, ids: Set<Int>) {
        let image = createMarkImage(ids: ids)
        self.selectedMapImage = MapImageModel(image: image, ids: ids)
        self.setupPlacemark(placemark: placemark, ids: ids, image: image)
    }
    
    func createPlaceMarks() {
        let mapObjects = self.mapView.mapWindow.map.mapObjects
        mapObjects.clear()
        if !self.groupedObjects.contains(where: {$0.ids == self.selectedIDs}) {
            self.selectedIDs = []
            self.objects = []
            self.selectedMapImage = nil
        }
        for groupedObject in groupedObjects {
            let placemark = mapObjects.addPlacemark(with: YMKPoint(latitude: groupedObject.lt,
                                                                   longitude: groupedObject.ln))
            self.setupPlacemark(placemark: placemark,
                                ids: groupedObject.ids,
                                image: self.getImageForMark(ids: groupedObject.ids))
            self.placemarks.append(placemark)
        }
        mapObjects.addTapListener(with: self)
    }
    
    func getImageForMark(ids: Set<Int>) -> UIImage {
        if ids.isEmpty || self.currentZoom < show_price_zoom {
            return self.dotImage
        }
        if let selectedMapImage = selectedMapImage, selectedMapImage.ids == ids {
            return selectedMapImage.image
        }
        if let imageModel = self.mapImages.first(where: {$0.ids == ids}) {
            return imageModel.image
        }
        return UIImage(named: "geo")!
    }
    
    func createMarkImage(ids: Set<Int>) -> UIImage {
        guard let placemarkModel = self.groupedObjects.first(where: {$0.ids == ids}) else {return UIImage(named: "geo")!}
        let view = MapPointView.instanceFromNib()
        let stringPlacemark = placemarkModel.ids.count > 1 ? "\(placemarkModel.ids.count) от \(placemarkModel.lowerPrice.price)" : "\(placemarkModel.lowerPrice.price)"
        view.frame = CGRect(x: 0, y: 0, width: stringPlacemark.widthOfString(usingFont: Fonts.regular(size: 11)) + 12, height: 27)
        view.setupViews()
        view.setupPrice(stringPlacemark)
        if let object = object, ids.contains(object.id ?? 0) {
            self.selectedIDs = ids
            self.viewModel.selectObjectOnMap(ids: Array(ids))
            self.object = nil
        }
        view.setSelected(ids == self.selectedIDs)//(ids == self.selectedIDs)
        view.clipsToBounds = false
        view.layoutIfNeeded()
        return view.asImage()
    }
    
    func setupPlacemark(placemark: YMKPlacemarkMapObject, ids: Set<Int>, image: UIImage) {
        placemark.setIconWith(image)
        placemark.userData = ids
        if ids == self.selectedIDs {
            placemark.zIndex = 1
        }
    }
    
    func onClusterAdded(with cluster: YMKCluster) {
        
    }
    
    @IBAction func backPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterPressed() {
        self.openFilter(filterModel: self.viewModel.filterModel) { model in
            self.viewModel.filterModel = model
            self.getObjectsMap()
        }
    }
    
    @IBAction func locationPressed() {
        switch self.state {
        case .map, .emptyMap:
            if let location = VRLocationManager.shared.location {
                self.zoomMap(coor: location)
            }
        case .list:
            self.state = .map
        }
    }
    
    func getObjectsMap() {
        self.viewModel.getObjects(tlLat: self.mapView.mapWindow.map.visibleRegion.topLeft.latitude,
                                  tlLon: self.mapView.mapWindow.map.visibleRegion.topLeft.longitude,
                                  brLat: self.mapView.mapWindow.map.visibleRegion.bottomRight.latitude,
                                  brLon: self.mapView.mapWindow.map.visibleRegion.bottomRight.longitude,
                                  trLat: self.mapView.mapWindow.map.visibleRegion.topRight.latitude,
                                  trLon: self.mapView.mapWindow.map.visibleRegion.topRight.longitude,
                                  blLat: self.mapView.mapWindow.map.visibleRegion.bottomLeft.latitude,
                                  blLon: self.mapView.mapWindow.map.visibleRegion.bottomLeft.latitude)
    }
    
    private var indexOfCellBeforeDragging = 0
    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        return self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
}

extension MapController: MapView {
    
    func error(message: String) {
        self.openErrorAlert(message: message)
    }
    
    func showObjectsMap(_ objects: [ObjectShortModel]) {
        self.objects = objects
    }
    
    func showAuthAlert() {
        self.presentAuthAlert()
    }
    
    func showAlert(title: String, message: String) {
        self.openInfoAlert(title: title, descr: message)
    }
    
    func setupFavoriteLoading(id: Int?, objects: [ObjectShortModel]?, listObjects: [ObjectShortModel]?) {
        if let listObjects = listObjects {
            self.objectListView.objects = listObjects
        }
        self.objectListView.favoriteIDisLoading = id
        if let objects = objects {
            self.objects = objects
        } else {
            self.collectionView.reloadData()
        }
    }
    
    func setupListObjects(_ objects: [ObjectShortModel]) {
        self.objectListView.setObjects(objects)
    }
    
    func setupListLoading(_ isLoading: Bool) {
        self.objectListView.setupLoading(isLoading)
    }
    
    func setupMoreListLoading(_ isLoading: Bool) {
        self.objectListView.setupMoreLoading(isLoading)
    }
    
    func setupObjects(_ objects: [MapListItem], count: Int) {
        self.setupMapMarks(objects)
        self.objectListView.setCount(count)
        self.state = self.state == .list ? .list : ((objects.count == 0) ? .emptyMap : .map)
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.view.layoutSubviews()
        }
    }
    
    func setupCity(name: String) {
        self.citySelectionView.textLabel.text = name
    }
    
    func setupLoading(_ isLoading: Bool) {
        self.objectListView.setupLoading(isLoading)
        isLoading ? self.loader.startAnimating() : self.loader.stopAnimating()
    }
    
    func zoomMap(coor: CLLocationCoordinate2D) {
        var coorsToLocate = coor
        self.currentZoom = 12
        if let object = self.object {
            coorsToLocate = CLLocationCoordinate2D(latitude: object.latitude!,
                                                   longitude: object.longitude!)
            self.currentZoom = 18
        }
        self.mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: YMKPoint(latitude: coorsToLocate.latitude,
                                                     longitude: coorsToLocate.longitude) ,
                                    zoom: self.currentZoom,
                                    azimuth: 0,
                                    tilt: 0), animationType: YMKAnimation(type: .linear, duration: 0.5),
            cameraCallback: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        configureCollectionViewLayoutItemSize()
    }

    func calculateSectionInset() -> CGFloat { // should be overridden
        return 16
    }

    private func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat = calculateSectionInset()
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)

        collectionViewFlowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32,
                                                   height: 110)
    }

    private func indexOfMajorCell() -> Int {
        let itemWidth = collectionViewFlowLayout.itemSize.width
        let proportionalOffset = self.collectionView.collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems - 1, index))
        return safeIndex
    }
    
}

extension MapController: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let userPoint = mapObject as? YMKPlacemarkMapObject else {
            return true
        }
        if let ids = userPoint.userData as? Set<Int> {
            self.selectedIDs = ids
            self.viewModel.selectObjectOnMap(ids: Array(ids))
        }
        return true
    }
}

extension MapController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ObjectShortCollectionCellView.self),
                                                         for: indexPath) as? ObjectShortCollectionCellView {
            cell.setupModel(self.objects[indexPath.row])
            cell.clipsToBounds = false
            print("is loading \(self.objectListView.favoriteIDisLoading == self.objects[indexPath.row].id)")
            cell.objectShortView.favoriteButton.setupLoading(self.objectListView.favoriteIDisLoading == self.objects[indexPath.row].id)
            cell.favoriteAction = { [unowned self] in
                self.viewModel.selectedFavoriteEvent(self.objects[indexPath.row].id)
            }
            cell.action = { [unowned self] in
                NotificationCenter.default.post(name: .closeMenu, object: nil)
                ObjectController.openObjectController(viewController: self,
                                                      id: self.objects[indexPath.row].id,
                                                      filterModel: self.viewModel.filterModel)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32,
                      height: 110)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset

        // calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()

        // calculate conditions:
        let dataSourceCount = collectionView(collectionView!, numberOfItemsInSection: 0)
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < dataSourceCount && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        if didUseSwipeToSkipCell {
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = (UIScreen.main.bounds.width * CGFloat(snapToIndex)) - (CGFloat(snapToIndex) * 16) - (CGFloat(snapToIndex) * 8)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
        } else {
            print("velocity \(velocity)")
            if velocity != CGPoint(x: 0, y: 0) {
                let toValue = (UIScreen.main.bounds.width * CGFloat(indexOfMajorCell)) - (CGFloat(indexOfMajorCell) * 16) - (CGFloat(indexOfMajorCell) * 8)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                    scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                    scrollView.layoutIfNeeded()
                }, completion: nil)
            } else {
                let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
                self.collectionView.scrollToItem(at: indexPath,
                                                 at: .centeredHorizontally,
                                                 animated: true)
            }
        }
    }
    
}
