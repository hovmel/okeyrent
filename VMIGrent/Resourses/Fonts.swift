//
//  Fonts.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 26.05.2022.
//

import Foundation
import UIKit

class Fonts {
    
    class func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "Rubik-Bold", size: size)!
    }
    
    class func medium(size: CGFloat) -> UIFont {
        return UIFont(name: "Rubik-Medium", size: size)!
    }
    
    class func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "Rubik", size: size)!
    }
    
}
