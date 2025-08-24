//
//  FeaturesResponse.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 05.07.2022.
//

import Foundation

//class FeaturesResponse: BaseResponse {
//    
//    var objectsObjectBedsTypeDefinition: [FeatureModel]
//    
//    private enum CodingKeys: String, CodingKey {
//        case contactPhone = "contact_phone"
//        case contactEmail = "contact_email"
//        case userAgreement = "user_agreement"
//        case privacyPolicy = "privacy_policy"
//        case objectsFeaturesTypeDefinition = "ObjectsFeaturesTypeDefinition"
//        case objectsObjectBedsTypeDefinition = "ObjectsObjectBedsTypeDefinition"
//        case objectsTypeDefinition = "ObjectsTypeDefinition"
//        case objectsCheckInTypeDefinition = "ObjectsCheckInTypeDefinition"
//    }
//    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        contactPhone = try container.decode(.contactPhone)
//        contactEmail = try container.decode(.contactEmail)
//        userAgreement = try container.decode(.userAgreement)
//        privacyPolicy = try container.decode(.privacyPolicy)
//        objectsFeaturesTypeDefinition = try container.decode(.objectsFeaturesTypeDefinition)
//        objectsObjectBedsTypeDefinition = try container.decode(.objectsObjectBedsTypeDefinition)
//        objectsTypeDefinition = try container.decode(.objectsTypeDefinition)
//        objectsCheckInTypeDefinition = try container.decode(.objectsCheckInTypeDefinition)
//        
//        try super.init(from: decoder)
//    }
//
//    
//}
