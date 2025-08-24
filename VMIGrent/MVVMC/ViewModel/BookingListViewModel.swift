//
//  BookingListViewModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 11.07.2022.
//

import Foundation
import RxSwift

fileprivate let per_page_list_count: Int = 50

class BookingListViewModel: NSObject {
    
    private var service: BookingService!
    private var objectService: ObjectsService!
    var view: BookingListView!
    let disposeBag = DisposeBag()
    var bookings: [BookingModel] = []
    var total: Int = 1
    
    var currentPage: Int {
        let page = Int(self.bookings.count/per_page_list_count)
        if page == 0 {
            return 1
        }
        return page
    }
    
    init(view: BookingListView) {
        self.service = BookingService()
        self.objectService = ObjectsService()
        self.view = view
    }
    
    func updateBookings() {
        self.bookings.removeAll()
        self.getBookings()
    }
    
    func getBookings() {
        guard total > self.bookings.count || total == 0 else {return}
        self.view.setupLoading(true)
        self.service.getList(page: Int((self.bookings.count+50)/50),
                             perPage: per_page_list_count).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                if let total = response.meta?.total {
                    self.total = total
                }
                if let bookings = response.items {
                    self.bookings.append(contentsOf: bookings)
                    self.view.setupBookings(self.bookings)
                }
                return
            case .error(let error):
                 print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    func favoriteEvent(_ id: Int) {
        if let object = self.bookings.compactMap({$0.object}).first(where: {$0.id == id}) {
            if let inFavorite = object.inFavorite, inFavorite, let favoriteID = object.favoriteID {
                self.removeFavorite(objectID: id, id: favoriteID)
            } else if let id = object.id {
                self.addFavorite(id: id)
            }
        }
    }
    
    private func addFavorite(id: Int) {
        self.view.setupFavoriteLoading(id)
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
                    if let index = self.bookings.map({$0.object!}).firstIndex(where: {$0.id == id}) {
                        self.bookings[index].object!.inFavorite = true
                        self.bookings[index].object!.favoriteID = response.favoriteID
                    }
                    self.view.setupBookings(self.bookings)
                }
                break
            case .error(let error):
                print(error)
                return
            }
            self.view.setupFavoriteLoading(nil)
        }.disposed(by: self.disposeBag)
    }
    
    private func removeFavorite(objectID: Int, id: Int) {
        self.view.setupFavoriteLoading(objectID)
        self.objectService.removeFavorite(id: id).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            switch event {
            case .completed:
                return
            case .next(let response):
                if let index = self.bookings.map({$0.object!}).firstIndex(where: {$0.id == id}) {
                    self.bookings[index].object!.inFavorite = false
                    self.bookings[index].object!.favoriteID = nil
                }
                self.view.setupBookings(self.bookings)
                break
            case .error(let error):
                print(error)
                return
            }
            self.view.setupFavoriteLoading(nil)
        }.disposed(by: self.disposeBag)
    }
    
}

