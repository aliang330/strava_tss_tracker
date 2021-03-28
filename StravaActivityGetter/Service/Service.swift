//
//  Service.swift
//  StravaActivityGetter
//
//  Created by Allen on 5/27/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import Foundation
import SQLite

class Service {
    
    static let shared = Service()
    var accessToken = "4ee44aad5de0390feef4f120260f95b800196b71"
    var refreshToken = ""
    
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
    
    
    enum NetworkError: Error{
        case url
        case statusCode
        case decodingError
        case dataNil
    }
    
    //    func asyncFetchActivities(before: Int) throws -> [Activity] {
    //        var activities = [Activity]()
    //        var data: Data?
    //        var response: URLResponse?
    //        var error: Error?
    //
    //
    //        let urlString = "https://www.strava.com/api/v3/athlete/activities?before=\(before)&per_page=50"
    //        guard let url = URL(string: urlString) else { throw NetworkError.url }
    //        var request = URLRequest(url: url)
    //
    //        request.httpMethod = "GET"
    //        request.allHTTPHeaderFields = ["accept" : "application/json", "content-type" : "application/json", "authorization" : "Bearer \(accessToken)"]
    //        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    //        //        request.setValue("Bearer f47fa62ea41d74910424fbcd7593ce5d28b5f23b", forHTTPHeaderField: "Authorization")
    //        URLSession.shared.dataTask(with: request) { (fetchedData, res, err) in
    //            data = fetchedData
    //            response = res
    //            error = err
    //        }.resume()
    //
    //        if error != nil {
    //            throw NetworkError.statusCode
    //        }
    //        guard let unwrappedData = data else {
    //            throw NetworkError.dataNil
    //        }
    //        do {
    //            activities = try JSONDecoder().decode([Activity].self, from: unwrappedData)
    //        } catch {
    //            throw NetworkError.decodingError
    //        }
    //
    //        return activities
    //
    //    }
    
    func fetchActivities(before: Int, completion: @escaping ([Activity]?, Error?)-> ()){
        let dg = DispatchGroup()
        dg.enter()
        let urlString = "https://www.strava.com/api/v3/athlete/activities?before=\(before)&per_page=100"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["accept" : "application/json", "content-type" : "application/json", "authorization" : "Bearer \(accessToken)"]
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //        request.setValue("Bearer f47fa62ea41d74910424fbcd7593ce5d28b5f23b", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(nil, error)
                return
            }
            guard let data = data else { return }
            //            print(String(data: data, encoding: .utf8))
            do {
                let decodedData = try JSONDecoder().decode([Activity].self, from: data)
                completion(decodedData, nil)
            } catch {
                completion(nil, error)
            }
            
        }.resume()
    }
    
    func getDetailedActivity(id: Int, completion: @escaping (Activity?, Error?) -> ()){
        let urlString = "https://www.strava.com/api/v3/activities/\(id)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["accept" : "application/json", "content-type" : "application/json", "authorization" : "Bearer \(accessToken)"]
        
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if error != nil {
                completion(nil, error)
                return
            }
            guard data != nil else { return }
            do {
                let decodedData = try JSONDecoder().decode(Activity.self, from: data!)
                completion(decodedData, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
        
    }
    
    func fetchStreamByActivityId(id: Int, completion: @escaping (Stream?, Error?) -> ()) {
        let urlString = "https://www.strava.com/api/v3/activities/\(id)/streams?keys=watts&key_by_type=true"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
        request.httpMethod = "Get"
        request.allHTTPHeaderFields = ["accept" : "application/json", "content-type" : "application/json", "authorization" : "Bearer \(accessToken)"]
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("error with request" , error as Any)
                completion(nil, error)
                return
            }
            let statusCode = response as? HTTPURLResponse
            if statusCode?.statusCode == 200  {
                guard let data = data  else { return }
                //                print(String(data: data, encoding: .utf8))
                do {
                    let decodedData = try JSONDecoder().decode(Stream.self, from: data)
                    completion(decodedData, nil)
                } catch {
                    print("error decoding json ", error)
                    completion(nil, error)
                }
            } else {
                print("request unsuccessful")
            }
        }.resume()
    }
    
    func getAccessToken(completion: @escaping (Error?) -> ()) {
        let urlString = "https://www.strava.com/oauth/token?client_id=48591&client_secret=028e94311d343a7d046101b900bb11de63620158&code=\(CODE)&grant_type=authorization_code"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("error getting access token", error as Any)
                completion(error)
                return
            }
            //            print(String(data: data!, encoding: .utf8))
            let statusCode = response as? HTTPURLResponse
            if statusCode?.statusCode == 200  {
                guard let data = data  else { return }
                do {
                    let decodedData = try JSONDecoder().decode(Authorization.self, from: data)
                    self.accessToken = decodedData.access_token ?? ""
                    self.refreshToken = decodedData.refresh_token ?? ""
                    print(self.accessToken)
                    print(self.refreshToken)
                    completion(nil)
                } catch {
                    completion(error)
                    print("error decoding authorization json", error)
                }
            }
        }.resume()
        
    }
    
    func migrateData(completion: @escaping () ->()) {
        let databaseUrl = FileManager.documentDirectoryURL.appendingPathComponent("database.sqlite3")
        //            print(databaseUrl.path)
        do {
            let db = try Connection(databaseUrl.path)
            self.db = db
        } catch {
            print(error)
        }
        
        let createTable = activityTable.create { (table) in
            table.column(id, primaryKey: true)
            table.column(name)
            table.column(movingTime)
            table.column(startDate)
            table.column(self.powerData)
            table.column(tssData)
        }
        guard let db = db else {
            print("error unwrapped db")
            return
        }
        do {
            try db.run(createTable)
        } catch {
            print(error)
        }
        
        let dg = DispatchGroup()
        var activitiesNotInDB = [Activity]()
        var powerData = [Int : String]()
        var tssDataDic = [Int : Int]()
        dg.enter()
        fetchActivities(before: Int(Date().timeIntervalSince1970)) { (fetchedActivities, error) in
            if error != nil {
                print(error)
                return
            }
            guard let fetchedActivities = fetchedActivities else {
                print("error unwrapping fetched activities")
                return
            }
            
            for activity in fetchedActivities {
                print("fetched: ", activity.id)
                do {
                    let count = try db.scalar(self.activityTable.filter(self.id == activity.id).count)
                    if count == 0 {
                        activitiesNotInDB.append(activity)
                    }
                } catch {
                    print("error db scalar", error)
                }
            }
            
            for activity in activitiesNotInDB {
                dg.enter()
                print(activity.id)
                self.fetchStreamByActivityId(id: activity.id) { (stream, error) in
                    print("requested")
                    if error != nil {
                        print(error)
                        return
                    }
                    guard let stream = stream else {
                        return
                    }
                    guard let unwrappedStream = stream.watts?.data else {
                        powerData[activity.id] = ""
                        dg.leave()
                        return
                        
                    }
                    
                    let unwrappedPowerData = unwrappedStream.compactMap{$0}
                    var powerDataString = ""
                    tssDataDic[activity.id] = Int(Analyze.shared.calculateTSS(data: unwrappedPowerData, movingTime: activity.moving_time))
                    
                    for power in unwrappedPowerData {
                        powerDataString += "\(power),"
                    }
                    powerDataString.remove(at: powerDataString.index(before: powerDataString.endIndex))
                    powerData[activity.id] = powerDataString
                    dg.leave()
                }
                
            }
            dg.leave()
        }
        dg.notify(queue: .main) {
            print(activitiesNotInDB.count)
            for activity in activitiesNotInDB {
                guard let powerDataString = powerData[activity.id] else { return }
                self.insertActivity(activity: activity, powerData: powerDataString, tss: tssDataDic[activity.id] ?? 0)
                
            }
            completion()
        }
    }
    
    func insertActivity(activity: Activity, powerData: String, tss: Int) {
      
            print("insert func")
            let insert = self.activityTable.insert(self.id <- activity.id, self.name <- activity.name, self.movingTime <-
                activity.moving_time, self.startDate <- activity.start_date, self.powerData <- powerData, self.tssData <- tss)
            guard let db = self.db else {
                print("db not here")
                return }
            do {
                try db.run(insert)
                print("inserted \(activity.id)")
            } catch {
                print(error)
            }
        
    }
    
    
    
    func fetchedAndSaveStarredSegments(completion: @escaping (Error?) ->()) {
        Database.shared.createSegmentTable()
        let url = URL(string: "https://www.strava.com/api/v3/segments/starred")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["accept" : "application/json", "content-type" : "application/json", "authorization" : "Bearer \(accessToken)"]
        
        URLSession.shared.dataTask(with: request) { (data, res, err) in
            if err != nil {
                completion(err)
            }
            guard let data = data else { return }
//            print(String(data: data, encoding: .utf8))
            do {
                let decodedData = try JSONDecoder().decode([Segment].self, from: data)
                for segment in decodedData {
                    Database.shared.insertSegment(segment: segment)
                }
                completion(nil)
            } catch {
                completion(error)
            }
        }.resume()
    }
    
    
    
    func fetchSegmentEfforts(for id: Int, completion: @escaping ([SegmentEffort]?, Error?) -> ()) {
        let url = URL(string: "https://www.strava.com/api/v3/segment_efforts?segment_id=\(id)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["accept" : "application/json", "content-type" : "application/json", "authorization" : "Bearer \(accessToken)"]
        
        
        URLSession.shared.dataTask(with: request) { (fetchedData, fetchedResponse, error) in
            if error != nil {
                completion(nil, error)
            }
            guard let fetchedData = fetchedData else { return }
            
            do {
                let decodedData = try JSONDecoder().decode([SegmentEffort].self, from: fetchedData)
                completion(decodedData, nil)
            } catch {
                print(String(data: fetchedData, encoding: .utf8))
                completion(nil, error)
            }
        }.resume()
    }
    
    func fetchHeartRateStreamNotInDatabaseAndSave(for id: Int, completion: @escaping () -> ()) {
        let url = URL(string: "https://www.strava.com/api/v3/activities/\(id)/streams?keys=heartrate&key_by_type=true")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["accept" : "application/json", "content-type" : "application/json", "authorization" : "Bearer \(accessToken)"]
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error)
                completion()
            }
            
            guard let data = data else {
                print("error unrapping data")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(Stream.self, from: data)
                guard let heartrateData = decodedData.heartrate?.data else {
                    completion()
                    return
                }
                let cleanedUpData = heartrateData.compactMap {$0}
                Database.shared.insertHeartrateStream(for: id, heartrateStream: cleanedUpData)
                completion()
            } catch {
                print(String(data: data, encoding: .utf8))
                completion()
            }
        }.resume()
    }
    
}



