//
//  RegionsViewModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 20.07.2022.
//

import Foundation
import RxSwift

class RegionsViewModel: NSObject {

    private var service: ObjectsService!
    var view: RegionsView!
    var cities: [CityModel] = []
    var total: Int = 1
    
    var search: String? {
        didSet {
            NSObject.cancelPreviousPerformRequests(withTarget: self,
                                                   selector: #selector(self.updateCities),
                                                   object: nil)
            self.perform(#selector(self.updateCities), with: nil, afterDelay: 0.3)
        }
    }
    
    let disposeBag = DisposeBag()
    
    init(view: RegionsView) {
        self.service = ObjectsService()
        self.view = view
    }
    
    @objc func updateCities() {
        self.cities.removeAll()
        self.getCities()
    }
    
    @objc func getCities() {
        guard total > self.cities.count || total == 0 else {return}
        self.view.setupLoading(true)
        self.service.getCities(orderField: self.search, page: Int((self.cities.count+50)/50), perPage: 50).subscribe { [weak self] event in
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
                if let cities = response.items {
                    self.cities.append(contentsOf: cities)
                    self.view.setCities(self.cities)
                }
                return
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
}

