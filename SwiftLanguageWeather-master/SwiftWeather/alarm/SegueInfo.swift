//
//  SegueInfo.swift
//  SwiftWeather
//
//  Created by edward.gao on 05/01/2018.
//  Copyright © 2018 Jake Lin. All rights reserved.
//

import Foundation
import Foundation

struct SegueInfo {
    var curCellIndex: Int
    var isEditMode: Bool
    var label: String
    var mediaLabel: String
    var mediaID: String
    var repeatWeekdays: [Int]
    var enabled: Bool
    var snoozeEnabled: Bool
}
