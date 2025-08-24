//
//  ReviewCellViewModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 22.07.2022.
//

import Foundation

struct ReviewCellViewModel: Encodable {
    var id: ReviewRateType
    var rate: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "type_id"
        case rate = "rate"
    }
    
    var dict: [String: Any] {
        return ["type_id":self.id.rawValue,
                "rate":self.rate]
    }
    
    func encode(from encoder: Encoder) throws {
       var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
       try container.encode(self.rate, forKey: .rate)
   }
    
    var json: String {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(self) {
            if let jsonString = String(data: jsonData, encoding: .utf8)?.replacingOccurrences(of: "\\", with: "") {
                print(jsonString)
                return jsonString
            }
        }
        return ""
    }
}
