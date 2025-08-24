//
//  String+localization.swift
//  Abonent
//
//  Created by Mikhail Koroteev on 15.12.2020.
//

import Foundation

extension String {
    public func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.current, value: "", comment: "")
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
