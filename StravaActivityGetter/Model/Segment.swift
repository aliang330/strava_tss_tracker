//
//  Segment.swift
//  StravaActivityGetter
//
//  Created by Allen Liang on 8/11/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import Foundation

struct Segment: Codable {
    var id: Int = 0
    var name: String = ""
    var pr_time: Int? = 0
    var average_grade: Double = 0.0
    var distance: Double = 0.0
    var elevation_high: Double = 0.0
    var elevation_low: Double = 0.0
}
