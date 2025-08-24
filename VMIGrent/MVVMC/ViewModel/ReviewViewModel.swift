//
//  ReviewViewModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 22.07.2022.
//

import Foundation
import RxSwift

class ReviewViewModel: NSObject {

    private var service: ReviewService!
    var view: ReviewView!
    
    let disposeBag = DisposeBag()
    
    var model: ReviewOutputModel!
    var object: ObjectModel!
    
    init(view: ReviewView, object: ObjectModel) {
        self.service = ReviewService()
        self.view = view
        self.object = object
        self.model = ReviewOutputModel(id: object.id ?? 0)
    }
    
    func setMark(type: ReviewRateType, rate: Int) {
        if let index = self.model.marks.firstIndex(where: {$0.id == type}) {
            self.model.marks[index].rate = rate
        }
        self.view.setupButtonEnabled(self.model.marks.filter({$0.rate > 0}).count == 4)
    }
    
    @objc func sendReview() {
        self.view.setupLoading(true)
        self.service.createReview(id: self.model.id,
                                  review: self.model.comment,
                                  rates: self.model.rates).subscribe { [weak self] event in
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
                    self.view.openSuccess()
                }
                return
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
}



