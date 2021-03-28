//
//  SegmentEffort.swift
//  StravaActivityGetter
//
//  Created by Allen Liang on 8/13/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import Foundation

struct SegmentEffort: Codable {
    var id: Int = 0
    var moving_time: Int = 0
    var start_date: String = ""
    var average_watts: Double? = 0.0
    var average_heartrate: Double? = 0.0
    var max_heartrate: Double? = 0.0
    var segment: SegmentInfo = SegmentInfo()
}

struct SegmentInfo: Codable {
    var id: Int = 0
}
