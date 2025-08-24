//
//  FavoritesViewModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 11.07.2022.
//

import Foundation
import RxSwift

class FavoritesViewModel: NSObject {
    
    private var service: ObjectsService!
    var view: FavoritesView!
    let disposeBag = DisposeBag()
    var favorites: [ObjectShortModel] = []
    
    init(view: FavoritesView) {
        self.service = ObjectsService()
        self.view = view
    }
    
    func getFavorites() {
        self.view.setupLoading(true)
        self.service.getFavorites(orderField: nil, page: nil, perPage: nil).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                if let objects = response.items {
                    self.favorites = objects
                }
                self.view.setupFavorites(self.favorites)
                return
            case .error(let error):
                 print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    
    func removeFavorite(id: Int) {
        guard let favoriteID = self.favorites.first(where: {$0.id == id})?.favoriteID else {return}
        self.view.setupFavoriteLoading(true, id: favoriteID)
        self.service.removeFavorite(id: favoriteID).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupFavoriteLoading(false, id: nil)
            switch event {
            case .completed:
                return
            case .next(let response):
                if let message = response.errorText {
                    self.view.error(message)
                } else {
                    self.favorites.removeAll(where: {$0.favoriteID == favoriteID})
                    self.view.setupFavorites(self.favorites)
                }
                return
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
}


