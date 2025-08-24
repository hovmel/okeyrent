//
//  ObjectsFeaturesTypeDefinition.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 28.06.2022.
//

import Foundation

enum ObjectsFeaturesType: String, Decodable {
    case feature = "FEATURE"
    case security = "SECURITY"
    case rule = "RULE"
}
