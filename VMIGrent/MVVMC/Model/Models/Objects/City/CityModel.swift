//
//  CityModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 20.06.2022.
//

import Foundation

struct CityModel: Decodable {
    var id: Int
    var ident: String
    var name: String
    var description: String?
    var picture: PictureModel?
    var objectsCounter: Int?
    var latitude: Double?
    var longitude: Double?
    var region: RegionModel?
    
    var listCellModel: ListCellModel {
        return ListCellModel(title: self.name,
                             descr: String.makeVariants(self.objectsCounter ?? 0),
                             picture: self.picture?.original)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case ident
        case name
        case description
        case picture
        case objectsCounter = "objects_counter"
        case latitude
        case longitude
        case region
    }
}
