//
//  ReviewOutputModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 22.07.2022.
//

import Foundation

struct ReviewOutputModel {
    var id: Int
    var comment: String?
    var marks: [ReviewCellViewModel] = ReviewRateType.allCases.map({ReviewCellViewModel(id: $0, rate: 0)})
    var rates: [[String:Any]] {
        let dic = marks.map({$0.dict})
        return dic
    }
}
