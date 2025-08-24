//
//  ObjectModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 17.06.2022.
//

import Foundation

class ObjectModel: BaseResponse {
    var id: Int?
    var ident: String?
    var createdAt: Int?
    var name: String?
    var description: String?
//    var description_attractions: String
    var ownerID: Int?
    var owner: OwnerModel?
    var bookingPeriodId: BookingPeriod?
    var bookingPeriod: BookingPeriodModel?
    var typeID: ObjectsType?
    var type: ObjectTypeModel?
    var area: Int?
    var roomsCounter: Int?
    var guestsCounter: Int?
    var bedroomsCounter: Int?
    var bedsCounter: Int?
    var rate: Double?
    var timeZone: Int?
    var picture: PictureModel?
    var priceDay: Int?
    var priceMonth: Int?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var cityId: Int?
    var city: CityModel?
    var regionID: Int?
    var region: RegionModel?
    var floor: Int?
    var checkInTypeId: ObjectCheckIn?
    var checkInType: ObjectCheckInModel?
    var checkInTimeStart: String?
    var checkInTimeEnd: String?
    var checkOutTimeEnd: String?
    var bookingCancelPercent: Int?
    var bookingCancelHours: Int?
    var bookingMinDays: Int?
    var bookingMinMonths: Int?
    var maxDaysToBooking: Int?
    var reviewsCounter: Int?
    var bookingsCounter: Int?
    var favoritesCounter: Int?
//    var beds: [BedModel]
    var features: [FeatureModel]?
    var pictures: [ObjectPictureModel]?
    var inFavorite: Bool?
    var favoriteID: Int?
    var hasReview: Bool?
//    var object_rates: []
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        //    var description_attractions: String
        //    var owner:
        owner = try container.decodeIfPresent(.owner)
        id = try container.decodeIfPresent(.id)
        ident = try container.decodeIfPresent(.ident)
        createdAt = try container.decodeIfPresent(.createdAt)
        name = try container.decodeIfPresent(.name)
        description = try container.decodeIfPresent(.description)
        ownerID = try container.decodeIfPresent(.ownerID)
        bookingPeriodId = try container.decodeIfPresent(.bookingPeriodId)
        bookingPeriod = try container.decodeIfPresent(.bookingPeriod)
        typeID = try container.decodeIfPresent(.typeID)
        type = try container.decodeIfPresent(.type)
        area = try container.decodeIfPresent(.area)
        roomsCounter = try container.decodeIfPresent(.roomsCounter)
        guestsCounter = try container.decodeIfPresent(.guestsCounter)
        bedroomsCounter = try container.decodeIfPresent(.bedroomsCounter)
        bedsCounter = try container.decodeIfPresent(.bedsCounter)
        rate = try container.decodeIfPresent(.rate)
        timeZone = try container.decodeIfPresent(.timeZone)
        picture = try container.decodeIfPresent(.picture)
        priceDay = try container.decodeIfPresent(.priceDay)
        priceMonth = try container.decodeIfPresent(.priceMonth)
        address = try container.decodeIfPresent(.address)
        latitude = try container.decodeIfPresent(.latitude)
        longitude = try container.decodeIfPresent(.longitude)
        cityId = try container.decodeIfPresent(.cityId)
        city = try container.decodeIfPresent(.city)
        regionID = try container.decodeIfPresent(.regionID)
        region = try container.decodeIfPresent(.region)
        floor = try container.decodeIfPresent(.floor)
        checkInTypeId = try container.decodeIfPresent(.checkInTypeId)
        checkInType = try container.decodeIfPresent(.checkInType)
        checkInTimeStart = try container.decodeIfPresent(.checkInTimeStart)
        checkInTimeEnd = try container.decodeIfPresent(.checkInTimeEnd)
        checkOutTimeEnd = try container.decodeIfPresent(.checkOutTimeEnd)
        bookingCancelPercent = try container.decodeIfPresent(.bookingCancelPercent)
        bookingCancelHours = try container.decodeIfPresent(.bookingCancelHours)
        bookingMinDays = try container.decodeIfPresent(.bookingMinDays)
        bookingMinMonths = try container.decodeIfPresent(.bookingMinMonths)
        maxDaysToBooking = try container.decodeIfPresent(.maxDaysToBooking)
        reviewsCounter = try container.decodeIfPresent(.reviewsCounter)
        bookingsCounter = try container.decodeIfPresent(.bookingsCounter)
        favoritesCounter = try container.decodeIfPresent(.favoritesCounter)
//        beds = try container.decode(.beds)
        features = try container.decodeIfPresent(.features)
        pictures = try container.decodeIfPresent(.pictures)
        inFavorite = try container.decodeIfPresent(.inFavorite)
        favoriteID = try container.decodeIfPresent(.favoriteID)
        hasReview = try container.decodeIfPresent(.hasReview)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case owner
        case id
        case ident
        case createdAt = "created_at"
        case name
        case description
    //  case description_attractions
        case ownerID = "owner_id"
    //  case owner
        case bookingPeriodId = "booking_period_id"
        case bookingPeriod = "booking_period"
        case typeID = "type_id"
        case type
        case area
        case roomsCounter = "rooms_counter"
        case guestsCounter = "guests_counter"
        case bedroomsCounter = "bedrooms_counter"
        case bedsCounter = "beds_counter"
        case rate
        case timeZone = "time_zone"
        case picture
        case priceDay = "price_day"
        case priceMonth = "price_month"
        case address
        case latitude
        case longitude
        case cityId = "city_id"
        case city
        case regionID = "region_id"
        case region
        case floor
        case checkInTypeId = "check_in_type_id"
        case checkInType = "check_in_type"
        case checkInTimeStart = "check_in_time_start"
        case checkInTimeEnd = "check_in_time_end"
        case checkOutTimeEnd = "check_out_time_end"
        case bookingCancelPercent = "booking_cancel_percent"
        case bookingCancelHours = "booking_cancel_hours"
        case bookingMinDays = "booking_min_days"
        case bookingMinMonths = "booking_min_months"
        case maxDaysToBooking = "max_days_to_booking"
        case reviewsCounter = "reviews_counter"
        case bookingsCounter = "bookings_counter"
        case favoritesCounter = "favorites_counter"
//        case beds
        case features
        case pictures
        case inFavorite = "in_favorite"
        case favoriteID = "favorite_id"
        case hasReview = "has_review"
    }
    
    var cancelRules: String {
        return "Бесплатная отмена бронирования за \(String.makeHours(self.bookingCancelHours ?? 48)). После будет списан невозвратный платеж в размере \(self.bookingCancelPercent ?? 50)%."
    }
}
