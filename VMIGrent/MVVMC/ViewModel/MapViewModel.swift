//
//  MapViewModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 17.06.2022.
//

import Foundation
import RxSwift
import CoreLocation

class MapViewModel {
    
    private var service: ObjectsService!
    var view: MapView!
    
    var city: CityModel!
    
    var filterModel: FilterModel = FilterModel()
    
    let disposeBag = DisposeBag()
    
    var mapSelectedObjects: [Int] = []
    var mapListItems: [MapListItem] = []
    var objectsIDs: [Int] = []
    var objects: [ObjectShortModel] = []
    var selectedObjects: [ObjectShortModel] = []
    
    var total: Int = 1
    
    init(view: MapView) {
        self.service = ObjectsService()
        self.view = view
    }
    
    func viewDidOpen() {
        self.view.zoomMap(coor: CLLocationCoordinate2D(latitude: self.city.latitude ?? 0,
                                                       longitude: self.city.longitude ?? 0))
    }
    
    func getObject(by id: Int) -> ObjectShortModel? {
        return self.objects.first(where: {$0.id == id})
    }
    
    func selectedFavoriteEvent(_ id: Int) {
        guard AuthManager.shared.authComplete() else {self.view.showAuthAlert();return}
        if let object = self.selectedObjects.first(where: {$0.id == id}) {
            if object.inFavorite, let id = object.favoriteID {
                self.removeFavorite(objectID: object.id, id: id, isFromSelected: true)
            } else {
                self.addFavorite(id: object.id, isFromSelected: true)
            }
        }
    }
    
    func favoriteEvent(_ id: Int) {
        guard AuthManager.shared.authComplete() else {self.view.showAuthAlert();return}
        if let object = self.objects.first(where: {$0.id == id}) {
            if object.inFavorite, let id = object.favoriteID {
                self.removeFavorite(objectID: object.id, id: id)
            } else {
                self.addFavorite(id: object.id)
            }
        }
    }
    
    func selectObjectOnMap(ids: [Int]) {
        self.mapSelectedObjects = ids
        self.view.setupListLoading(true)
        self.service.getList(ids: ids, page: nil, perPage: nil).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupListLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                if let objects = response.items {
                    self.selectedObjects = objects
                    self.view.showObjectsMap(objects)
                }
                return
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    private func addFavorite(id: Int, isFromSelected: Bool = false) {
        self.view.setupFavoriteLoading(id: id, objects: nil, listObjects: nil)
        self.service.addFavorite(id: id).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            switch event {
            case .completed:
                return
            case .next(let response):
                if isFromSelected, let index = self.selectedObjects.firstIndex(where: {$0.id == id}) {
                    self.selectedObjects[index].inFavorite = true
                    self.selectedObjects[index].favoriteID = response.favoriteID
                    self.view.showObjectsMap(self.selectedObjects)
                } else if let index = self.objects.firstIndex(where: {$0.id == id}) {
                    self.objects[index].inFavorite = true
                    self.objects[index].favoriteID = response.favoriteID
                    self.view.setupListObjects(self.objects)
                }
                break
            case .error(let error):
                print(error)
                return
            }
            self.view.setupFavoriteLoading(id: nil,
                                           objects: self.selectedObjects,
                                           listObjects: self.objects)
        }.disposed(by: self.disposeBag)
    }
    
    private func removeFavorite(objectID: Int, id: Int, isFromSelected: Bool = false) {
        self.view.setupFavoriteLoading(id: objectID, objects: nil, listObjects: nil)
        self.service.removeFavorite(id: id).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            switch event {
            case .completed:
                return
            case .next(let response):
                if isFromSelected, let index = self.selectedObjects.firstIndex(where: {$0.id == objectID}) {
                    self.selectedObjects[index].inFavorite = false
                    self.selectedObjects[index].favoriteID = nil
                    self.view.showObjectsMap(self.selectedObjects)
                } else if let index = self.objects.firstIndex(where: {$0.id == objectID}) {
                    self.objects[index].inFavorite = false
                    self.objects[index].favoriteID = nil
                    self.view.setupListObjects(self.objects)
                }
                break
            case .error(let error):
                print(error)
                return
            }
            self.view.setupFavoriteLoading(id: nil,
                                           objects: self.selectedObjects,
                                           listObjects: self.objects)
        }.disposed(by: self.disposeBag)
    }
    
    func getObjectList() {
        self.view.setupListLoading(true)
        self.service.getList(ids: self.objectsIDs, page: Int((self.objects.count+50)/50), perPage: 50).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupListLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                if let total = response.meta?.total {
                    self.total = total
                }
                if let objects = response.items {
                    self.objects = objects
                    self.view.setupListObjects(self.objects)
                }
                return
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    func getMoreObjectList() {
        guard total > self.objects.count || total == 0 else {return}
        self.view.setupMoreListLoading(true)
        self.service.getList(ids: self.objectsIDs, page: Int((self.objects.count+50)/50), perPage: 50).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupMoreListLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                if let total = response.meta?.total {
                    self.total = total
                }
                if let objects = response.items {
                    self.objects.append(contentsOf: objects)
                    self.view.setupListObjects(self.objects)
                    print("total objects \(self.objects.count)")
                }
                return
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    func getObjects(tlLat: Double, tlLon: Double, brLat: Double, brLon: Double, trLat: Double, trLon: Double, blLat: Double, blLon: Double) {
        self.view.setupLoading(true)
        self.service.getListMap(tl_lat: tlLat,
                                tl_lon: tlLon,
                                br_lat: brLat,
                                br_lon: brLon,
                                tr_lat: trLat,
                                tr_lon: trLon,
                                bl_lat: blLat,
                                bl_lon: blLon,
                                start_date: self.filterModel.startDate == nil ? nil : DateFormatter.yyyyMMdd.string(from: self.filterModel.startDate!),
                                end_date: self.filterModel.endDate == nil ? nil : DateFormatter.yyyyMMdd.string(from: self.filterModel.endDate!),
                                price_day_from: self.filterModel.minPrice,
                                price_day_to: self.filterModel.maxPrice,
                                type_id: self.filterModel.types.map({$0.id.rawValue}),
                                rooms_counter: self.filterModel.rooms.map({$0.value}),
                                bedrooms_counter: self.filterModel.bed,
                                feature_ids: self.filterModel.features.map({$0.id})
        ).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                if let message = response.message {
//                    self.view.error(message: message)
                } else {
                    var count = response.objects?.count ?? 0
                    let objects = (response.objects ?? []).prefix(2000)
                    self.mapListItems = Array(objects)
                    self.objectsIDs = objects.map({$0.id})
                    if let meta = response.meta {
                        self.filterModel.meta = meta
                        count = meta.objects_counter ?? 0
                    }
                    if let city = response.city {
                        self.view.setupCity(name: city.name)
                    }
                    self.view.setupObjects(self.mapListItems, count: count)
                }
                return
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
}
