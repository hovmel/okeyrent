//
//  BookingViewModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.07.2022.
//

import Foundation
import RxSwift

class BookingViewModel: NSObject {
    
    private var service: BookingService!
    var view: BookingView!
    let disposeBag = DisposeBag()
    var filterModel: FilterModel!
    var object: ObjectModel!
    var booking: BookingModel!
    
    init(view: BookingView, object: ObjectModel, filterModel: FilterModel) {
        self.service = BookingService()
        self.view = view
        self.object = object
        self.filterModel = filterModel
    }
    
    func calculateBooking() {
        guard let id = self.object.id else {return}
        self.view.setupCalculateLoading(true)
        self.service.calculateBooking(objectID: id,
                                      comment: "",
                                      startDate: DateFormatter.yyyyMMdd.string(from: self.filterModel.startDate!),
                                      endDate: DateFormatter.yyyyMMdd.string(from: self.filterModel.endDate!),
                                      startTime: DateFormatter.hoursAndMnutes.string(from: self.filterModel.startTime!),
                                      endTime: DateFormatter.hoursAndMnutes.string(from: self.filterModel.endTime!)).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupCalculateLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                if let message = response.message {
                    self.view.calculateError(message: message)
                } else {
                    self.booking = response
                    self.view.setupInfo(object: self.object, booking: response)
                }
                return
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
    func createBooking() {
        guard let id = self.object.id else {return}
        if let bookingMinDays = self.object.bookingMinDays, bookingMinDays != 0, bookingMinDays > self.filterModel.days {
            self.view.error(message: "Минимальное количество дней: \(bookingMinDays)")
            return
        }
//        if let maxDays = self.object.maxDaysToBooking, maxDays != 0, maxDays < self.filterModel.days {
//            self.view.error(message: "Максимальное количество дней: \(maxDays)")
//            return
//        }
        self.view.setupLoading(true)
        self.service.createBooking(objectID: id,
                                   comment: "",
                                   startDate: DateFormatter.yyyyMMdd.string(from: self.filterModel.startDate!),
                                   endDate: DateFormatter.yyyyMMdd.string(from: self.filterModel.endDate!),
                                   startTime: DateFormatter.hoursAndMnutes.string(from: self.filterModel.startTime!),
                                   endTime: DateFormatter.hoursAndMnutes.string(from: self.filterModel.endTime!)).subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            self.view.setupLoading(false)
            switch event {
            case .completed:
                return
            case .next(let response):
                if let message = response.message {
                    self.view.error(message: message)
                } else {
                    self.booking = response
                    if let paymentUrl = response.paymentUrl, let url = URL(string: paymentUrl) {
                        self.view.openPayment(url: url)
                    }
                }
                return
            case .error(let error):
                print(error)
                return
            }
        }.disposed(by: self.disposeBag)
    }
    
}


