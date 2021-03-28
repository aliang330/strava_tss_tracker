//
//  Activity.swift
//  StravaActivityGetter
//
//  Created by Allen on 5/24/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import Foundation

class Activity: Codable {
//    static var createStatement: String {
//        return """
//        CREATE TABLE Activity(
//        Id INT PRIMARY KEY NOT NULL,
//        Name TEXT,
//        Distance REAL,
//        ElapsedTime INT
//        );
//        """
//    }
    init() {
        self.name = ""
        self.id = 0
        self.distance = 0.0
        self.elapsed_time = 0
        self.start_date = "0"
        self.moving_time = 0
        self.type = "unknown"
        self.device_watts = false
        self.external_id = ""
    }
    var name: String
    var id: Int
    var distance: Double
    var elapsed_time: Int
    var start_date: String
    var moving_time: Int
    var type: String
    var device_watts: Bool?
    var external_id: String?
//    let segment_efforts: [Effort]?
}
//
//class Effort: Codable {
//    let name: String
//    let elapsed_time: Int
//}
