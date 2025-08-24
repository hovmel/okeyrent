//
//  CitiesViewModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 20.06.2022.
//

import Foundation
import RxSwift

class CitiesViewModel: NSObject {
    
    private var service: ObjectsService!
    var view: CitiesView!
    
    var search: String? {
        didSet {
            NSObject.cancelPreviousPerformRequests(withTarget: self,
                                                   selector: #selector(self.getCities),
                                                   object: nil)
            self.perform(#selector(self.getCities), with: nil, afterDelay: 1)
        }
    }
    
    let disposeBag = DisposeBag()
    
    init(view: CitiesView) {
        self.service = ObjectsService()
        self.view = view
    }
    
    func getDashboard() {
        self.view.setupLoading(true)
        self.service.getDashboard().subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                self.view.setCities(response.cities)
                self.view.setObjects(response.objects)
                return
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    @objc func getCities() {
        self.view.setupLoading(true)
        self.service.getCities(orderField: self.search, page: nil, perPage: nil).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                if let cities = response.items {
                    self.view.setCities(cities)
                }
                return
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
}
