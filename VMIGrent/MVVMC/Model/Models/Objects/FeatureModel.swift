//
//  FeatureModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 17.06.2022.
//

import Foundation
import UIKit

struct FeatureModel: Decodable {
    var id: Int
    var ident: String
    var name: String
    var description: String?
    
    var image: UIImage? {
        switch self.ident {
        case "conditioner":
            return UIImage(named: "feature_cold")!
        case "shower":
            return UIImage(named: "feature_shower")!
        case "televizion":
            return UIImage(named: "feature_tv")!
        case "bathroom":
            return UIImage(named: "feature_bath")!
        case "hairdryer":
            return UIImage(named: "feature_hot")!
        case "kitchen":
            return UIImage(named: "feature_kitchen")!
        case "phone":
            return UIImage(named: "feature_phone")!
        case "washing-machine":
            return UIImage(named: "feature_clean")!
        case "internet":
            return UIImage(named: "feature_wifi")!
        case "refrigerator":
            return UIImage(named: "feature_eat")!
        case "iron":
            return UIImage(named: "feature_lane")!
        case "elevator":
            return UIImage(named: "feature_lift")!
        case "double-bed":
            return UIImage(named: "feature_doublebed")!
        case "single-bed":
            return UIImage(named: "feature_bed")!
        case "baby-bed":
            return UIImage(named: "feature_kid")!
        case "pets":
            return UIImage(named: "feature_pets")!
        case "hygiene-products":
            return UIImage(named: "feature_beauty")!
        case "wi-fi":
            return UIImage(named: "feature_wifi")!
        default:
            return nil
        }
    }
}

enum Feature: String, Decodable {
    
    case conditioner = "conditioner"
    case shower = "shower"
    case tv = "televizion"
    case bathroom = "bathroom"
    case dryer = "hairdryer"
    case kitchen = "kitchen"
    case phone = "phone"
    case wash = "washing-machine"
    case internet = "internet"
    case fridge = "refrigerator"
    case iron = "iron"
    case elevator = "elevator"
    case doublebed = "double-bed"
    case singlebed = "single-bed"
    case childbed = "baby-bed"
    case pets = "pets"
    case products = "hygiene-products"
    case wifi = "wi-fi"
    
    
}
