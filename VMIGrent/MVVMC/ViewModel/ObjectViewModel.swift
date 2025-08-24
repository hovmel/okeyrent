//
//  ObjectViewModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 30.06.2022.
//

import Foundation
import RxSwift

class ObjectViewModel: NSObject {
    
    private var service: ObjectsService!
    private var reviewService: ReviewService!
    var view: ObjectView!
    let disposeBag = DisposeBag()
    var id: Int!
    var object: ObjectModel?
    var filterModel: FilterModel?
    var reviews: [ReviewModel] = []
    
    init(view: ObjectView, id: Int, filterModel: FilterModel? = nil) {
        self.service = ObjectsService()
        self.reviewService = ReviewService()
        self.view = view
        self.id = id
        self.filterModel = filterModel
    }
    
    func getReviews() {
        self.reviewService.getList(id: self.id).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                if let reviews = response.items {
                    self.reviews = reviews
                }
                self.view.setObject(self.object!, reviews: self.reviews)
                return
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    func getObject() {
        self.view.setupLoading(true)
        self.service.getDetail(id: self.id).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            switch event {
            case .completed:
                return
            case .next(let response):
                if let message = response.message {
//                    self.view.er
                } else {
                    self.object = response
                }
                self.getReviews()
                return
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    func favoriteEvent() {
        guard AuthManager.shared.authComplete() else {self.view.showAuthAlert();return}
        guard let object = object, let id = object.id else {return}
        if let inFavorite = object.inFavorite, inFavorite, let favoriteID = object.favoriteID {
            self.removeFavorite(objectID: id, id: favoriteID)
        } else if let id = object.id {
            self.addFavorite(id: id)
        }
    }
    
    private func addFavorite(id: Int) {
        self.view.setupFavoriteLoading(true)
        self.service.addFavorite(id: id).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            switch event {
            case .completed:
                return
            case .next(let response):
                guard let object = self.object else {
                    return
                }
                if let message = response.message {
                    self.view.error(message)
                } else {
                    object.inFavorite = true
                    object.favoriteID = response.favoriteID
                }
                self.view.setObject(object, reviews: self.reviews)
                break
            case .error(let error):
                print(error)
                return
            }
            self.view.setupFavoriteLoading(false)
        }.disposed(by: self.disposeBag)
    }
    
    private func removeFavorite(objectID: Int, id: Int) {
        self.view.setupFavoriteLoading(true)
        self.service.removeFavorite(id: id).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            switch event {
            case .completed:
                return
            case .next(let response):
                guard let object = self.object else {
                    return
                }
                if let message = response.message {
                    self.view.error(message)
                } else {
                    object.inFavorite = false
                    object.favoriteID = nil
                }
                self.view.setObject(object, reviews: self.reviews)
                break
            case .error(let error):
                print(error)
                return
            }
            self.view.setupFavoriteLoading(false)
        }.disposed(by: self.disposeBag)
    }
    
}


