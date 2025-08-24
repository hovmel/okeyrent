//
//  RoomModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 05.07.2022.
//

import Foundation

enum RoomType: CaseIterable {
    case one
    case two
    case three
    case more
    
    var title: String {
        switch self {
        case .one:
            return "Одна"
        case .two:
            return "Две"
        case .three:
            return "Три"
        case .more:
            return "Четыре и более"
        }
    }
    
    var value: Int {
        switch self {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        case .more:
            return 4
        }
    }
}
