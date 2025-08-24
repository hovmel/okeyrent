//
//  BookingModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 10.07.2022.
//

import Foundation

class BookingModel: BaseResponse {
    
    var id: Int?
    var createdAt: Int?
    var updatedAt: Int?
    var objectID: Int?
    var object: ObjectModel?
    var stateID: BookingsStateType?
    var state: BookingsState?
    var cancelPercent: Int? = 50
    var cancelHours: Int? = 48
    var comment: String?
    var startDate: String?
    var endDate: String?
    var freeCancelDate: String?
    var paymentDate: Int?
    var acceptDate: Int?
    var priceTotalWithoutDiscount: Double?
    var priceTotal: Double?
    var basePrice: Double?
    var discount: Double?
    var penalty: Double?
    var paymentUrl: String?
    var intercomCode: String?
    
    var cancelPrice: Double? {
        if let cancelPercent = cancelPercent,
            let freeCancelDate = self.freeCancelDate,
            let date = DateFormatter.full.date(from: freeCancelDate),
            date < Date() {
            return Double(self.priceTotal!) * (Double((cancelPercent))/100)
        }
        return nil
    }
    
    var cancelPriceTotal: Double {
        if let cancelPrice = cancelPrice, let priceTotal = self.priceTotal {
            return priceTotal - cancelPrice
        }
//            return Double(self.priceTotal!) * (Double((100-cancelPercent))/100)
        return Double(self.priceTotal!)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case objectID = "object_id"
        case object = "object"
        case stateID = "state_id"
        case state = "state"
        case cancelPercent = "cancel_percent"
        case cancelHours = "cancel_hours"
        case comment = "comment"
        case startDate = "start_date"
        case endDate = "end_date"
        case freeCancelDate = "free_cancel_date"
        case paymentDate = "payment_date"
        case acceptDate = "accept_date"
        case priceTotalWithoutDiscount = "price_total_without_discount"
        case priceTotal = "price_total"
        case basePrice = "base_price"
        case discount = "discount"
        case penalty = "penalty"
        case paymentUrl = "payment_url"
        case intercomCode = "intercom_code"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(.id)
        createdAt = try container.decodeIfPresent(.createdAt)
        updatedAt = try container.decodeIfPresent(.updatedAt)
        objectID = try container.decodeIfPresent(.objectID)
        object = try container.decodeIfPresent(.object)
        stateID = try container.decodeIfPresent(.stateID)
        state = try container.decodeIfPresent(.state)
        cancelPercent = try container.decodeIfPresent(.cancelPercent)
        cancelHours = try container.decodeIfPresent(.cancelHours)
        comment = try container.decodeIfPresent(.comment)
        startDate = try container.decodeIfPresent(.startDate)
        endDate = try container.decodeIfPresent(.endDate)
        freeCancelDate = try container.decodeIfPresent(.freeCancelDate)
        paymentDate = try container.decodeIfPresent(.paymentDate)
        acceptDate = try container.decodeIfPresent(.acceptDate)
        priceTotalWithoutDiscount = try container.decodeIfPresent(.priceTotalWithoutDiscount)
        priceTotal = try container.decodeIfPresent(.priceTotal)
        basePrice = try container.decodeIfPresent(.basePrice)
        discount = try container.decodeIfPresent(.discount)
        penalty = try container.decodeIfPresent(.penalty)
        paymentUrl = try container.decodeIfPresent(.paymentUrl)
        intercomCode = try container.decodeIfPresent(.intercomCode)
        
        try super.init(from: decoder)
    }
    
    var bookingRulesCellModel: BookingRulesCellModel {
        var isCancel = false
        var isEnd = false
        var isCall = false
        var isReview = false
        var isDetail = false
        switch self.stateID {
        case .done:
            isReview = !(self.object?.hasReview ?? false)
            isDetail = false
        case .canceled, .declined:
            isDetail = false
        case .confirmPending:
            isEnd = false
            isCancel = false
            isCall = true
        default:
            if let startDate = startDate, let date = DateFormatter.full.date(from: startDate) {
                isEnd = Date() > date
            }
            isCancel = true
            isCall = true
        }
        return BookingRulesCellModel(descr: self.cancelRules,
                                     isCancel: isCancel,
                                     isEnd: isEnd,
                                     isCall: isCall,
                                     isReview: isReview,
                                     isDetail: isDetail)
    }
    
    var cancelRules: String {
        return "Бесплатная отмена бронирования за \(String.makeHours(self.cancelHours ?? 48)). После будет списан невозвратный платеж в размере \(self.cancelPercent ?? 50)%."
    }
    
    var detailCellView: BookingDetailCellModel {
        var status: String = "Оплачено"
        switch self.stateID {
        case .needPayment:
            status = "Ожидает оплаты"
        default:
            status = "Оплачено"
        }
        return BookingDetailCellModel(number: "\(self.id ?? 0)",
                                      price: self.priceTotal?.price ?? 0.price,
                                      status: status,
                                      guests: self.object?.guestsCounter ?? 0)
    }
    
    var infoCellView: BookingInformationCellViewModel {
        var startDateStr: String = ""
        var endDateStr: String = ""
        var startTimeStr: String = ""
        var endTimeStr: String = ""
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru_RU")
        if let startDate = self.startDate, let date = DateFormatter.full.date(from: startDate) {
            startDateStr = DateFormatter.ddMM.string(from: date)
            startTimeStr = "\(DateFormatter.ddMM.weekdaySymbols[calendar.component(.weekday, from: date) - 1].capitalizingFirstLetter()), " + DateFormatter.hoursAndMnutes.string(from: date)
        }
        if let endDate = self.endDate, let date = DateFormatter.full.date(from: endDate) {
            endDateStr = DateFormatter.ddMM.string(from: date)
            endTimeStr = "\(DateFormatter.ddMM.weekdaySymbols[calendar.component(.weekday, from: date) - 1].capitalizingFirstLetter()), " + DateFormatter.hoursAndMnutes.string(from: date)
        }
        return BookingInformationCellViewModel(startDate: startDateStr,
                                               endDate: endDateStr,
                                               startTime: startTimeStr,
                                               endTime: endTimeStr)
    }
    
    var intercomString: String? {
        if let intercomCode = self.intercomCode {
            return "Код домофона: \(intercomCode)"
        }
        return nil
    }
    
}
