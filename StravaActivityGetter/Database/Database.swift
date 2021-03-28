//
//  Database.swift
//  StravaActivityGetter
//
//  Created by Allen Liang on 8/11/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import Foundation
import SQLite

class Database {
    
    static let shared = Database()
    
    var db: Connection?
    
    let activityTable = Table("activities")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let movingTime = Expression<Int>("moving_time")
    let startDate = Expression<String>("start_date")
    let powerData = Expression<String>("power_data")
    let tssData = Expression<Int>("tss")
    
    let segmentTable = Table("segments")
    let segmentId = Expression<Int>("id")
    let segmentName = Expression<String>("name")
    let segmentPr = Expression<Int>("pr")
    let segmentDistance = Expression<Double>("distance")
    let segmentAverageGrade = Expression<Double>("average_grade")
    let segmentElevationHigh = Expression<Double>("elevation_high")
    let segmentElevationLow = Expression<Double>("elevation_low")
    
    let segmentEffortTable = Table("segment_efforts")
    let segmentEffortId = Expression<Int>("id")
    let segmentEffortMovingTime = Expression<Int>("moving_time")
    let segmentEffortStartDate = Expression<String>("start_date")
    let segmentEffortAverageWatts = Expression<Double?>("average_watts")
    let segmentEffortAverageHeartrate = Expression<Double?>("average_heartrate")
    let segmentEffortMaxHeartRate = Expression<Double?>("max_heartrate")
    let segmentEffortSegmentId = Expression<Int>("segment_id")
    
    let heartRateStreamTable = Table("heartrate_streams")
    let heartRateStreamId = Expression<Int>("id")
    let heartRateStreamData = Expression<String>("data")
    
    //    enum connectionError : Error {
    //        case connection
    //    }
    
    func connectDatabase()  {
        let databaseUrl = FileManager.documentDirectoryURL.appendingPathComponent("database.sqlite3")
        do {
            self.db = try Connection(databaseUrl.path)
        } catch {
            print(error)
        }
    }
    
    func getSegments() -> [Segment] {
        connectDatabase()
        var segments = [Segment]()
        
        do {
            for segment in try db!.prepare(segmentTable) {
                var seg = Segment()
                seg.id = segment[id]
                seg.name = segment[name]
                seg.pr_time = segment[segmentPr]
                seg.distance = segment[segmentDistance]
                seg.average_grade = segment[segmentAverageGrade]
                seg.elevation_high = segment[segmentElevationHigh]
                seg.elevation_low = segment[segmentElevationLow]
                segments.append(seg)
            }
        } catch {
            print(error)
        }
        return segments
    }
    
    func createSegmentEffortTable() {
        connectDatabase()
        
        let createSegmentEffortTable = segmentEffortTable.create { (segmentEffort) in
            segmentEffort.column(segmentEffortId, primaryKey: true)
            segmentEffort.column(segmentEffortMovingTime)
            segmentEffort.column(segmentEffortStartDate)
            segmentEffort.column(segmentEffortAverageWatts)
            segmentEffort.column(segmentEffortAverageHeartrate)
            segmentEffort.column(segmentEffortMaxHeartRate)
            segmentEffort.column(segmentEffortSegmentId)
        }
        
        guard let db = self.db else { return }
        
        do {
            try db.run(createSegmentEffortTable)
            print("segment effort table created")
        } catch {
            print(error)
        }
    }
    
    func insertSegmentEfforts(efforts: [SegmentEffort]) {
        createSegmentEffortTable()
        guard let db = self.db else { return }
        
        for effort in efforts {
            let insert = self.segmentEffortTable.insert(self.segmentEffortId <- effort.id,
                                                        self.segmentEffortMovingTime <- effort.moving_time,
                                                        self.segmentEffortStartDate <- effort.start_date,
                                                        self.segmentEffortAverageWatts <- effort.average_watts,
                                                        self.segmentEffortAverageHeartrate <- effort.average_heartrate,
                                                        self.segmentEffortMaxHeartRate <- effort.max_heartrate,
                                                        self.segmentEffortSegmentId <- effort.segment.id)
            
            do {
                try db.run(insert)
                print("inserted segment effort: \(effort.id)")
            } catch {
                print(error)
            }
        }
    }
    
    func saveStarredSegmentEfforts(completion: @escaping () -> ()) {
        if db == nil {
            connectDatabase()
        }
        
        var segmentIds = [Int]()
        
        do {
            for effort in try db!.prepare(segmentTable) {
                segmentIds.append(effort[self.segmentId])
            }
        } catch {
            print(error)
        }
        
        for id in segmentIds {
            Service.shared.fetchSegmentEfforts(for: id) { (efforts, error) in
                if error != nil {
                    print(error)
                    completion()
                    return
                }
                guard let efforts = efforts else { return }
//                self.insertSegmentEfforts(efforts: efforts)
                print("called completion")
                completion()
            }
        }
    }
    
    func getSegmentEfforts(for id: Int) -> [SegmentEffort] {
        var segmentEfforts = [SegmentEffort]()
        
        connectDatabase()
        let filter = segmentEffortTable.filter(segmentEffortId == id)
        do {
            for effort in try db!.prepare(filter) {
                var newEffort = SegmentEffort()
                newEffort.id = effort[segmentEffortId]
                newEffort.moving_time = effort[segmentEffortMovingTime]
                newEffort.start_date = effort[segmentEffortStartDate]
                newEffort.average_watts = effort[segmentEffortAverageWatts]
                newEffort.average_heartrate = effort[segmentEffortAverageHeartrate]
                newEffort.max_heartrate = effort[segmentEffortMaxHeartRate]
                newEffort.segment.id = effort[segmentEffortSegmentId]
                
                segmentEfforts.append(newEffort)
            }
        } catch {
            print(error)
        }
        return segmentEfforts
    }
    
    func getAllActivities() -> [ActivityWithPower] {
        var activities = [ActivityWithPower]()
        
        connectDatabase()
        
        do {
            for activity in try db!.prepare(activityTable) {
                var newActivity = ActivityWithPower()
                newActivity.id = activity[id]
//                newActivity.name = activity[name]
//                newActivity.distance = activity[distance]
                newActivity.elapsed_time = activity[id]
//                newActivity.start_date = activity[id]
//                newActivity.moving_time = activity[id]
//                newActivity.type = activity[id]
//                newActivity.device_watts = activity[id]
                let powerStringArray = activity[powerData].components(separatedBy: ",")
                newActivity.powerData = powerStringArray.map {Int($0) ?? 0}
//                newActivity.tss = activity[id]
                activities.append(newActivity)
            }
        } catch {
            print(error)
        }
        print(activities.count)
        return activities
    }
    
    func insertSegment(segment: Segment) {
        var prTime = 0
        if segment.pr_time != nil {
            prTime = segment.pr_time!
        }
        
        let insert = self.segmentTable.insert(self.segmentId <- segment.id,
                                              self.segmentName <- segment.name,
                                              self.segmentPr <- prTime,
                                              self.segmentDistance <- segment.distance,
                                              self.segmentAverageGrade <- segment.average_grade,
                                              self.segmentElevationHigh <- segment.elevation_high,
                                              self.segmentElevationLow <- segment.elevation_low)
        guard let db = self.db else { return }
        
        do {
            try db.run(insert)
            print("inserted Segment: ", segment.id)
        } catch {
            print(error)
        }
    }
    
    func createSegmentTable() {
       connectDatabase()
        
        let createTable = segmentTable.create { (segment) in
            segment.column(segmentId, primaryKey: true)
            segment.column(segmentName)
            segment.column(segmentPr)
            segment.column(segmentDistance)
            segment.column(segmentAverageGrade)
            segment.column(segmentElevationHigh)
            segment.column(segmentElevationLow)
        }
        
        guard let db = db else { return }
        do {
            try db.run(createTable)
            print("segment table created")
        } catch {
            print(error)
        }
    }
    
    func getAllActivityIds() -> [Int]{
        connectDatabase()
        
        var ids = [Int]()
        
        do {
            for activity in try db!.prepare(activityTable.select(id)) {
                ids.append(activity[id])
            }
        } catch {
            print(error)
        }
        
        return ids
    }
    
    func createHeartrateTable() {
        let createTable = heartRateStreamTable.create{ (table) in
            table.column(heartRateStreamId, primaryKey: true)
            table.column(heartRateStreamData)
        }
        guard let db = db else { return }
        
        do {
            try db.run(createTable)
            print("heartrate table created")
        } catch {
            print(error)
        }
    }
    
    func insertHeartrateStream(for id: Int, heartrateStream: [Int]) {
        connectDatabase()
        createHeartrateTable()
        
        var heartrateString = ""
        
        for i in heartrateStream {
            heartrateString += "\(i),"
        }
        heartrateString.remove(at: heartrateString.index(before: heartrateString.endIndex))
        
        let insert = self.heartRateStreamTable.insert(heartRateStreamId <- id,
                                                      heartRateStreamData <- heartrateString)
        
        
        do {
            try db?.run(insert)
            print("heartrate inserted for id: ", id)
        } catch {
            print(error)
        }
        
    }
    
}



