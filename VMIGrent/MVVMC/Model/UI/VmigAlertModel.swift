//
//  VmigAlertModel.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 14.07.2022.
//

import Foundation

struct VmigAlertModel {
    var title: String = ""
    var descr: String? = nil
    var leftAction: (() -> ())? = nil
    var rightAction: (() -> ())? = nil
    var leftTitle: String? = nil
    var rightTitle: String? = nil
}
