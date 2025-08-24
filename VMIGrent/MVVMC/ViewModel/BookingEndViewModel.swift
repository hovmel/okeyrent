//
//  BookingEndViewModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 13.07.2022.
//

import Foundation
import RxSwift

class BookingEndViewModel: NSObject {
    
    private var service: BookingService!
    var view: BookingEndView!
    let disposeBag = DisposeBag()
    var booking: BookingModel!
    
    init(view: BookingEndView, booking: BookingModel) {
        self.service = BookingService()
        self.view = view
        self.booking = booking
    }
    
    func endBooking() {
        self.view.setupLoading(true)
        self.service.finishBooking(id: self.booking.id!).subscribe { [weak self] event in
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
    
    func cancelBooking() {
        self.view.setupLoading(true)
        self.service.cancelBooking(id: self.booking.id!).subscribe { [weak self] event in
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


