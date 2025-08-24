//
//  BedType.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 05.07.2022.
//

import Foundation

enum BedType: Int, CaseIterable {
    case one = 1
    case two
    case three
    case four
    
    var title: String {
        switch self {
        case .one:
            return "1"
        case .two:
            return "2"
        case .three:
            return "3"
        case .four:
            return "4 и более"
        }
    }
}
