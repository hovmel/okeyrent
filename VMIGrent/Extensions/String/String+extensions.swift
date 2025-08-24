//
//  String+extensions.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 27.06.2022.
//

import Foundation
import UIKit

extension String {
    
    func getEstimatedHeight(_ width: CGFloat, attributes: [NSAttributedString.Key : Any]) -> CGFloat {
        let estimatedFrame = self.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                                               options: [.usesLineFragmentOrigin, .usesFontLeading],
                                               attributes: attributes,
                                               context: nil)
        return estimatedFrame.height
    }
    
    func getEstimatedHeight(_ width: CGFloat, font: UIFont) -> CGFloat {
        return self.getEstimatedHeight(width, attributes: [.font: font])
    }
    
    func getEstimatedHeight(_ width: CGFloat, fontSize: CGFloat) -> CGFloat {
        return self.getEstimatedHeight(width, attributes: [.font: UIFont.systemFont(ofSize: fontSize)])
    }
    
    func getEstimatedMediumHeight(_ width: CGFloat, fontSize: CGFloat) -> CGFloat {
        return self.getEstimatedHeight(width, attributes: [.font: UIFont.boldSystemFont(ofSize: fontSize)])
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    func makeTime() -> String {
        let startDF = DateFormatter.hoursAndMnutes
        let endDF = DateFormatter.hoursAndMnutes
        let date = startDF.date(from: self) ?? Date()
        return endDF.string(from: date)
    }
    
//    func makePriceString() -> String? {
//        var newStr = ""
//        var numberOfSpaces = count / 3
//        if count % 3 != 0 {
//            numberOfSpaces += 1
//        }
//        for i in 0..<numberOfSpaces {
//            if count % 3 != 0 {
//                if i == 0 {
//                    let start = self.index(0, offsetBy: count % 3)
//                    let end = str.index(str.endIndex, offsetBy: -6)
//                    let range = start..<end
//
//                    let mySubstring = str[range]
//                    newStr += substring(with: NSRange(location: 0, length: count % 3))
//                } else {
//                    newStr += substring(with: NSRange(location: (count % 3) + (i - 1) * 3, length: 3)) // -1?
//                }
//            } else {
//                if i != 0 {
//                    newStr += substring(with: NSRange(location: i * 3 - 1, length: 3))
//                } else {
//                    newStr += substring(with: NSRange(location: i * 3, length: 3))
//                }
//            }
//            newStr += " "
//        }
//        newStr += "руб."
//        return newStr
//    }
    
}

extension String {
    
    static func makeGuests(_ number: Int, withNumber: Bool = true) -> String {
        var str = ""
        switch number%100 {
        case 11, 12, 13, 14:
            str = "гостей"
        default:
            switch number%10 {
            case 1:
                str = "гость"
            case 2,3,4:
                str = "гостя"
            default:
                str = "гостей"
            }
        }
        if withNumber {
            str = "\(number) \(str)"
        }
        return str
    }
    
    static func makeBeds(_ number: Int, withNumber: Bool = true) -> String {
        var str = ""
        switch number%100 {
        case 11, 12, 13, 14:
            str = "кроватей"
        default:
            switch number%10 {
            case 1:
                str = "кровать"
            case 2,3,4:
                str = "кровати"
            default:
                str = "кроватей"
            }
        }
        if withNumber {
            str = "\(number) \(str)"
        }
        return str
    }
    
    static func makeRooms(_ number: Int, withNumber: Bool = true) -> String {
        var str = ""
        switch number%100 {
        case 11, 12, 13, 14:
            str = "комнат"
        default:
            switch number%10 {
            case 1:
                str = "комната"
            case 2,3,4:
                str = "комнаты"
            default:
                str = "комнат"
            }
        }
        if withNumber {
            str = "\(number) \(str)"
        }
        return str
    }
    
    static func makeBedrooms(_ number: Int, withNumber: Bool = true) -> String {
        var str = ""
        switch number%100 {
        case 11, 12, 13, 14:
            str = "спален"
        default:
            switch number%10 {
            case 1:
                str = "спальня"
            case 2,3,4:
                str = "спальни"
            default:
                str = "спален"
            }
        }
        if withNumber {
            str = "\(number) \(str)"
        }
        return str
    }
    
    static func makeHours(_ number: Int, withNumber: Bool = true) -> String {
        var str = ""
        switch number%100 {
        case 11, 12, 13, 14:
            str = "часов"
        default:
            switch number%10 {
            case 1:
                str = "час"
            case 2,3,4:
                str = "часа"
            default:
                str = "часов"
            }
        }
        if withNumber {
            str = "\(number) \(str)"
        }
        return str
    }
    
    static func makeNights(_ number: Int, withNumber: Bool = true) -> String {
        var str = ""
        switch number%100 {
        case 11, 12, 13, 14:
            str = "ночей"
        default:
            switch number%10 {
            case 1:
                str = "ночь"
            case 2,3,4:
                str = "ночи"
            default:
                str = "ночей"
            }
        }
        if withNumber {
            str = "\(number) \(str)"
        }
        return str
    }
    
    static func makeVariants(_ number: Int, withNumber: Bool = true) -> String {
        var str = ""
        switch number%100 {
        case 11, 12, 13, 14:
            str = "вариантов размещения"
        default:
            switch number%10 {
            case 1:
                str = "вариант размещения"
            case 2,3,4:
                str = "варианта размещения"
            default:
                str = "вариантов размещения"
            }
        }
        if withNumber {
            str = "\(number) \(str)"
        }
        return str
    }
    
}
