//
//  FilterModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 29.06.2022.
//

import Foundation

class FilterModel: NSObject, NSCopying {
    var startDate: Date?
    var endDate: Date?
    var startTime: Date?
    var endTime: Date?
    var meta: MapMetaModel?
    var minPrice: Int?
    var maxPrice: Int?
    var types: [ObjectsTypeDefinition] = []
    var features: [FeatureModel] = []
    var bed: Int?
    var rooms: [RoomType] = []
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = FilterModel(startDate: self.startDate,
                               endDate: self.endDate,
                               startTime: self.startTime,
                               endTime: self.endTime,
                               meta: self.meta,
                               minPrice: self.minPrice,
                               maxPrice: self.maxPrice,
                               types: self.types,
                               features: self.features,
                               bed: self.bed,
                               rooms: self.rooms)
        return copy
    }
    
    override init() {}
    
    init(startDate: Date?, endDate: Date?, startTime: Date?, endTime: Date?, meta: MapMetaModel?, minPrice: Int?, maxPrice: Int?, types: [ObjectsTypeDefinition], features: [FeatureModel], bed: Int?, rooms: [RoomType]) {
        self.startDate = startDate
        self.endDate = endDate
        self.startTime = startTime
        self.endTime = endTime
        self.meta = meta
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.types = types
        self.features = features
        self.bed = bed
        self.rooms = rooms
    }
    
    func clear() {
        self.minPrice = nil
        self.maxPrice = nil
        self.types.removeAll()
        self.features.removeAll()
        self.bed = nil
        self.rooms.removeAll()
    }
    
    var days: Int {
        guard let startDate = startDate, let endDate = endDate else {
            return 0
        }
        return Calendar.current.numberOfDaysBetween(startDate, and: endDate)
    }
    
    var dateStr: String {
        if let startDate = startDate, let endDate = endDate {
            return DateFormatter.ddMM.string(from: startDate) + "-" + DateFormatter.ddMM.string(from: endDate)
        } else if let startDate = startDate {
            return DateFormatter.ddMM.string(from: startDate)
        } else if let endDate = endDate {
            return DateFormatter.ddMM.string(from: endDate)
        } else {
            return "Выбрать даты"
        }
    }
}
