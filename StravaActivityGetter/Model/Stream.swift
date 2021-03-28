//
//  DataStream.swift
//  StravaActivityGetter
//
//  Created by Allen on 6/2/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import Foundation

struct Stream: Codable {
    let watts: DataStream?
    let heartrate: DataStream?
}

struct DataStream: Codable {
    let data: [Int?]?
}

