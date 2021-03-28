//
//  Activity.swift
//  StravaActivityGetter
//
//  Created by Allen on 5/24/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import Foundation

class ActivityWithPower {

    init() {
        self.name = ""
        self.id = 0
        self.distance = 0.0
        self.elapsed_time = 0
        self.start_date = "0"
        self.moving_time = 0
        self.type = "unknown"
        self.device_watts = false
        self.powerData = [Int]()
        self.tss = 0
        
    }
    var name: String
    var id: Int
    var distance: Double
    var elapsed_time: Int
    var start_date: String
    var moving_time: Int
    var type: String
    var device_watts: Bool?
    var powerData: [Int]
    var tss: Int
    
//    let segment_efforts: [Effort]?
}
//
//class Effort: Codable {
//    let name: String
//    let elapsed_time: Int
//}
