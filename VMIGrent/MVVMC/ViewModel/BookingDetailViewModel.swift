//
//  BookingDetailViewModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 11.07.2022.
//

import Foundation
import RxSwift

class BookingDetailViewModel: NSObject {
    
    private var service: BookingService!
    private var objectService: ObjectsService!
    weak private var view: BookingDetailView!
    let disposeBag = DisposeBag()
    var bookingID: Int!
    var booking: BookingModel?
    
    init(view: BookingDetailView, id: Int) {
        self.service = BookingService()
        self.objectService = ObjectsService()
        self.bookingID = id
        self.view = view
    }
    
    func getBooking() {
        self.view.setupLoading(true)
        self.view.setupLoadingLock(true)
        self.service.getDetail(id: self.bookingID).flatMap { [weak self] (bookingModel: BookingModel) -> Observable<LockResponse> in
            guard let self = self else {
                return Observable.empty()
            }
            self.view.setupLoading(false)
            self.booking = bookingModel
            self.view.setupBooking(bookingModel)
            return self.service.getLock(id: self.bookingID)
        }.subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupLoadingLock(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                if let key = response.lockKey, let serial = response.lockSerialNumber {
                    self.view.connectLock(response.lockConfig)
                    self.view.hideLock(false)
                } else {
                    self.view.hideLock(true)
                }
                break
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    func endBooking() {
        guard let id = self.booking?.id else {return}
        self.view.setupLoading(true)
        self.service.finishBooking(id: id).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                if let message = response.message {
                    self.view.error(message)
                } else {
                    self.view.endSuccess()
                }
                return
            case .error(let error):
                 print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    func favoriteEvent() {
        guard let object = self.booking?.object, let id = object.id else {return}
        if let inFavorite = object.inFavorite, inFavorite, let favoriteID = object.favoriteID {
            self.removeFavorite(id: favoriteID)
        } else {
            self.addFavorite(id: id)
        }
    }
    
    private func addFavorite(id: Int) {
        self.view.setupFavoriteLoading(true)
        self.objectService.addFavorite(id: id).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            switch event {
            case .completed:
                return
            case .next(let response):
                if let message = response.message {
                    self.view.error(message)
                } else {
                    if let object = self.booking?.object {
                        object.inFavorite = true
                        object.favoriteID = response.favoriteID
                    }
                }
                break
            case .error(let error):
                print(error)
                return
            }
            self.view.setupFavoriteLoading(false)
            self.view.setupBooking(self.booking!)
        }.disposed(by: self.disposeBag)
    }
    
    private func removeFavorite(id: Int) {
        self.view.setupFavoriteLoading(true)
        self.objectService.removeFavorite(id: id).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            switch event {
            case .completed:
                return
            case .next(let response):
                if self.booking!.object != nil {
                    self.booking!.object!.inFavorite = false
                    self.booking!.object!.favoriteID = nil
                }
                break
            case .error(let error):
                print(error)
                return
            }
            self.view.setupFavoriteLoading(false)
            self.view.setupBooking(self.booking!)
        }.disposed(by: self.disposeBag)
    }
    
    func openLock() {
        self.view.setupLoadingLock(true)
        self.service.openLock(id: self.bookingID).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            switch event {
            case .completed:
                return
            case .next(let response):
                if let message = response.errorText {
                    self.view.setupLoadingLock(false)
                    self.view.error(message)
                } else {
                    self.view.openLock()
                }
                break
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    func closeLock() {
        self.view.setupLoadingUnlock(true)
        self.service.closeLock(id: self.bookingID).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            switch event {
            case .completed:
                return
            case .next(let response):
                if let message = response.errorText {
                    self.view.setupLoadingUnlock(false)
                    self.view.error(message)
                } else {
                    self.view.closeLock()
                }
                break
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    func getLock() {
        self.view.setupLoadingLock(true)
        self.service.getLock(id: self.bookingID).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupLoadingLock(false)
            switch event {
            case .completed:
                return
            case .next(let response):
//                if let message = response.errorText {
//                    self.view.error(message)
//                } else
                if let key = response.lockKey, let serial = response.lockSerialNumber {
                    self.view.hideLock(false)
                    self.view.connectLock(response.lockConfig)
                } else {
                    self.view.hideLock(true)
                }
                break
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
}

