//
//  BookingService.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 03.07.2022.
//

import Foundation
import RxSwift
import Moya

class BookingService {
    
    var provider: MoyaProvider<BookingAPI> = MoyaProvider<BookingAPI>(plugins: moyaPlugins)
    
    func getDetail(id: Int) -> Observable<BookingModel> {
        return provider.rx.request(.getDetail(id),
                                   callbackQueue: DispatchQueue.main)
            .decode(BookingModel.self)
    }
    
    func getList(page: Int, perPage: Int) -> Observable<BookingListResponse> {
        return provider.rx.request(.getList(page, perPage),
                                   callbackQueue: DispatchQueue.main)
            .decode(BookingListResponse.self)
    }
    
    func createBooking(objectID: Int, comment: String?, startDate: String, endDate: String, startTime: String, endTime: String) -> Observable<BookingModel> {
        return provider.rx.request(.createBooking(objectID, comment, startDate, endDate, startTime, endTime),
                                   callbackQueue: DispatchQueue.main)
            .decode(BookingModel.self)
    }
    
    func calculateBooking(objectID: Int, comment: String?, startDate: String, endDate: String, startTime: String, endTime: String) -> Observable<BookingModel> {
        return provider.rx.request(.calculateBooking(objectID, comment, startDate, endDate, startTime, endTime),
                                   callbackQueue: DispatchQueue.main)
            .decode(BookingModel.self)
    }

    func cancelBooking(id: Int) -> Observable<BaseResponse> {
        return provider.rx.request(.cancelBooking(id),
                                   callbackQueue: DispatchQueue.main)
            .decode(BaseResponse.self)
    }
    
    func finishBooking(id: Int) -> Observable<BaseResponse> {
        return provider.rx.request(.finishBooking(id),
                                   callbackQueue: DispatchQueue.main)
            .decode(BaseResponse.self)
    }
    
    func openLock(id: Int) -> Observable<LockResponse> {
        return provider.rx.request(.openLock(id),
                                   callbackQueue: DispatchQueue.main)
            .decode(LockResponse.self)
    }
    
    func closeLock(id: Int) -> Observable<LockResponse> {
        return provider.rx.request(.closeLock(id),
                                   callbackQueue: DispatchQueue.main)
            .decode(LockResponse.self)
    }
    
    func getLock(id: Int) -> Observable<LockResponse> {
        return provider.rx.request(.getLock(id),
                                   callbackQueue: DispatchQueue.main)
            .decode(LockResponse.self)
    }

}





