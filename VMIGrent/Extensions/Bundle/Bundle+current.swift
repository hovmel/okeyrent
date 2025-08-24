//
//  Bundle+current.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 28.05.2022.
//

import Foundation

extension Bundle {
    static var current: Bundle {
        class __ { }
        return Bundle(for: __.self)
    }
    
    var releaseVersionNumber: String {
        return (infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
    var buildVersionNumber: String {
        return (infoDictionary?["CFBundleVersion"] as? String) ?? ""
    }

}

