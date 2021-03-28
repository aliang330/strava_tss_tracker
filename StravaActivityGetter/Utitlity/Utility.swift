//
//  Utility.swift
//  StravaActivityGetter
//
//  Created by Allen on 5/24/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import Foundation

class Utility {
    static let shared = Utility()
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
