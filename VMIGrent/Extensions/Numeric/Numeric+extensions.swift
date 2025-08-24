//
//  Numeric+extensions.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 10.07.2022.
//

import Foundation

extension Double {
    var price: String { (Formatter.withSeparator.string(for: Int((self/100))) ?? "") + " ₽" }
}

extension Int {
    var price: String { (Formatter.withSeparator.string(for: (self/100)) ?? "") + " ₽" }
}
