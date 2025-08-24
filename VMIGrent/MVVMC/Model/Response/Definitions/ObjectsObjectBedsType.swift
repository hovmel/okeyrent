//
//  ObjectsObjectBedsType.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 28.06.2022.
//

import Foundation

enum ObjectsObjectBedsType: String, Decodable {
    case singleBed = "SINGLE_BED"
    case doubleBed = "DOUBLE_BED"
    case singleSofa = "SINGLE_SOFA"
    case doubleSofa = "DOUBLE_SOFA"
    case bunkBed = "BUNK_BED"
}
