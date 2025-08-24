//
//  DefinitionManagers.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 28.06.2022.
//

import Foundation

class DefinitionManager {
    
    static let shared = DefinitionManager()
    
    private init() {}
    
    var contactPhone: String = ""
    var contactEmail: String = ""
    var userAgreement: String = ""
    var privacyPolicy: String = ""
    var objectsObjectBedsTypeDefinition: [ObjectsObjectBedsTypeDefinition] = []
    var objectsFeaturesTypeDefinition: [ObjectsFeaturesTypeDefinition] = []
    var objectsTypeDefinition: [ObjectsTypeDefinition] = []
    var bookingTypes: [BookingsState] = []
    var features: [FeatureModel] = []
}
