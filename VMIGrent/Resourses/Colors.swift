//
//  Colors.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 26.05.2022.
//

import Foundation
import UIKit

class Colors {
    
    class func getColor(_ id: Int) -> UIColor {
        switch id {
        case 0:
            return Colors.main
        case 1:
            return Colors.gray
        case 2:
            return Colors.mainBlack
        case 3:
            return Colors.attention
        case 4:
            return Colors.redAttention
        case 5:
            return Colors.lightRed
        case 6:
            return Colors.white
        case 7:
            return Colors.lightGreen
        case 8:
            return Colors.lightYellow
        case 9:
            return Colors.e3e3e3
        case 10:
            return Colors.F3EBDA
        case 11:
            return Colors.ABABAB
        default:
            return Colors.main
        }
    }
    
    static let main = #colorLiteral(red: 0.003921568627, green: 0.6392156863, blue: 0.5960784314, alpha: 1)
    static let gray = #colorLiteral(red: 0.6705882353, green: 0.6705882353, blue: 0.6705882353, alpha: 1)
    static let mainBlack = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
    static let attention = #colorLiteral(red: 1, green: 0.6588235294, blue: 0.003921568627, alpha: 1)
    static let redAttention = #colorLiteral(red: 0.9882352941, green: 0.007843137255, blue: 0.05490196078, alpha: 1)
    static let lightRed = #colorLiteral(red: 0.9529411765, green: 0.8549019608, blue: 0.8588235294, alpha: 1)
    static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let lightGreen = #colorLiteral(red: 0.8549019608, green: 0.9176470588, blue: 0.9137254902, alpha: 1)
    static let lightYellow = #colorLiteral(red: 0.9529411765, green: 0.9215686275, blue: 0.8549019608, alpha: 1)
    static let e3e3e3 = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
    static let f2f2f2 = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
    static let F3EBDA = #colorLiteral(red: 0.9529411765, green: 0.9215686275, blue: 0.8549019608, alpha: 1)
    static let ABABAB = #colorLiteral(red: 0.6705882353, green: 0.6705882353, blue: 0.6705882353, alpha: 1)
    static let DDDDDD = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
    
}
