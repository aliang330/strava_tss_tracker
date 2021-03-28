//
//  BestPowers.swift
//  StravaActivityGetter
//
//  Created by Allen on 6/2/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit

public var FTP = 260.0

class BestPowers: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let activityId = "3549648984"
//        Service.shared.fetchStreamByActivityId(id: activityId) { (stream, error) in
//            if error != nil {
//                return
//            }
//            guard let stream = stream else { return }
//            if let data = stream.watts?.data {
//                print(data.count)
//                let unwrappedData = data.compactMap { $0 }
//                let disconnectTime = Double(data.count - unwrappedData.count)
//                 //Double(unwrappedData.count) + disconnectTime
//                let TSS = Analyze.shared.calculateTSS(data: unwrappedData)
//
//                print(TSS)
//            }
//        }
        
//        getWeekTSS()
    }
    
//    func getWeekTSS() {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//
//        Service.shared.fetchActivities { (activities, error) in
//            if error != nil {
//                print("error fetching activities")
//                return
//            }
//            guard let activities = activities else { return }
//            var weekActivities = [Activity]()
//            for i in 0..<activities.count {
////                guard let dateInput = activities[i].start_date else { return }
//                if let date = formatter.date(from: dateInput) {
//                    let day = Calendar.current.component(.day, from: date)
//                    if day >= 1 && day <= 6 {
//                        weekActivities.append(activities[i])
//                    }
//                }
//            }
//            print(weekActivities)
//            var weekTSS = [Double]()
//            for i in 0..<weekActivities.count {
//                Service.shared.fetchStreamByActivityId(id: String(weekActivities[i].id)) { (stream, error) in
//                    if error != nil {
//                        print("error getting stream")
//                        return
//                    }
//                    guard let data = stream?.watts?.data else { return }
//                    let unwrappedData = data.compactMap { $0 }
////                    guard let movingTime = weekActivities[i].moving_time else { return }
//                    weekTSS.append(Analyze.shared.calculateTSS(data: unwrappedData, movingTime: Double(movingTime)))
//                    print(weekTSS)
//                }
//            }
//
//        }
//    }
}
