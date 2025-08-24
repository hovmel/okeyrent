//
//  CommonResponse.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 26.06.2022.
//

import Foundation

class CommonResponse: BaseResponse {
    
    var objectsObjectBedsTypeDefinition: [ObjectsObjectBedsTypeDefinition]
    var objectsFeaturesTypeDefinition: [ObjectsFeaturesTypeDefinition]
    var objectsTypeDefinition: [ObjectsTypeDefinition]
    var objectsCheckInTypeDefinition: [ObjectsCheckInTypeDefinition]
    var bookingsStateDefinition: [BookingsState]
    var contactPhone: String?
    var contactEmail: String?
    var userAgreement: String?
    var privacyPolicy: String?
    
    private enum CodingKeys: String, CodingKey {
        case contactPhone = "contact_phone"
        case contactEmail = "contact_email"
        case userAgreement = "user_agreement"
        case privacyPolicy = "privacy_policy"
        case objectsFeaturesTypeDefinition = "ObjectsFeaturesTypeDefinition"
        case objectsObjectBedsTypeDefinition = "ObjectsObjectBedsTypeDefinition"
        case objectsTypeDefinition = "ObjectsTypeDefinition"
        case objectsCheckInTypeDefinition = "ObjectsCheckInTypeDefinition"
        case bookingsStateDefinition = "BookingsStateDefinition"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        contactPhone = try container.decode(.contactPhone)
        contactEmail = try container.decode(.contactEmail)
        userAgreement = try container.decode(.userAgreement)
        privacyPolicy = try container.decode(.privacyPolicy)
        objectsFeaturesTypeDefinition = try container.decode(.objectsFeaturesTypeDefinition)
        objectsObjectBedsTypeDefinition = try container.decode(.objectsObjectBedsTypeDefinition)
        objectsTypeDefinition = try container.decode(.objectsTypeDefinition)
        objectsCheckInTypeDefinition = try container.decode(.objectsCheckInTypeDefinition)
        bookingsStateDefinition = try container.decode(.bookingsStateDefinition)
        
        try super.init(from: decoder)
    }

    
}

struct ObjectsTypeDefinition: Decodable {
    var id: ObjectsType
    var title: String
}

struct ObjectsFeaturesTypeDefinition: Decodable {
    var id: ObjectsFeaturesType
    var title: String
}

struct ObjectsObjectBedsTypeDefinition: Decodable {
    var id: ObjectsObjectBedsType
    var title: String
}

struct ObjectsCheckInTypeDefinition: Decodable {
    var id: ObjectCheckIn
    var title: String
    var description: String
}
