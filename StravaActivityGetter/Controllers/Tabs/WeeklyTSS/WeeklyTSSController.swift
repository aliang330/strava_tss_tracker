//
//  WeeklyTSSController.swift
//  StravaActivityGetter
//
//  Created by Allen Liang on 7/20/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit
import SQLite

class WeeklyTSSController: BaseListController {
    
    fileprivate let summaryCellId = "SummaryCellId"
    fileprivate let activityCellId = "activityCellId"
    var database: Connection!
    let activityTable = Table("activities")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let movingTime = Expression<Int>("moving_time")
    let startDate = Expression<String>("start_date")
    let powerData = Expression<String>("power_data")
    let tss = Expression<Int>("tss")
    var activities = [ActivityWithPower]()
    var firstDateOfWeek: Date?
    var lastDateOfWeek: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        connectDatabase()
        setDate()
        print(firstDateOfWeek!)
        filterDataByDate(begin: firstDateOfWeek!, end: lastDateOfWeek!)
        collectionView.register(SummaryViewCell.self, forCellWithReuseIdentifier: summaryCellId)
        collectionView.register(WeeklyActivityCell.self, forCellWithReuseIdentifier: activityCellId)
    }
    
    func setDate() {
        let (begin, end) = getWeekRange(date: Date())
        firstDateOfWeek = begin
        lastDateOfWeek = Calendar.current.date(byAdding: .day, value: 1, to: end)
    }
    
    func getWeekRange(date: Date) -> (Date, Date) {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)
        let day = calendar.component(.day, from: date)
        let firstDayOfWeek = day - dayOfWeek
        let firstDate = calendar.date(byAdding: .day, value: -dayOfWeek + 1, to: date)
        let lastDate = calendar.date(byAdding: .day, value: 7 - dayOfWeek,to: date)
        return (firstDate!, lastDate!)
    }
    
    func filterDataByDate(begin: Date, end: Date) {
        var activities = [ActivityWithPower]()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let firstDateString = df.string(from: firstDateOfWeek!)
        let lastDateString = df.string(from: lastDateOfWeek!)
        let filter = activityTable.filter(startDate > firstDateString && startDate < lastDateString)
        do {
            for activity in try database.prepare(filter) {
                let newActivity = ActivityWithPower()
                newActivity.id = activity[id]
                newActivity.name = activity[name]
                newActivity.moving_time = activity[movingTime]
                newActivity.start_date = activity[startDate]
                newActivity.tss = activity[tss]
                let powerStringArray = activity[powerData].components(separatedBy: ",")
                newActivity.powerData = powerStringArray.map {Int($0) ?? 0}
                activities.append(newActivity)
//                print("activity: \(newActivity.moving_time), powersize: \(newActivity.powerData.count)")
            }
        } catch {
            print(error)
        }
        self.activities = activities
        DispatchQueue.main.async {
            self.activities.reverse()
            self.collectionView.reloadData()
        }
    }
    
    func connectDatabase() {
        let databaseUrl = FileManager.documentDirectoryURL.appendingPathComponent("database.sqlite3")
        print(databaseUrl.path)
        do {
            let db = try Connection(databaseUrl.path)
            self.database = db
        } catch {
            print(error)
        }
    }
    
    
}

extension WeeklyTSSController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities.count + 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: summaryCellId, for: indexPath) as! SummaryViewCell
            cell.backgroundColor = .white
            cell.weeklyTSSControllerDelegate = self
            cell.weekChangeDelegate = self
            cell.activities = self.activities
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: activityCellId, for: indexPath) as! WeeklyActivityCell
            cell.backgroundColor = .white
            cell.weeklyTSSControllerDelegate = self
            cell.activity = activities[indexPath.row - 1]
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return .init(width: view.frame.width, height: 400)
        } else {
            return .init(width: view.frame.width
                , height: 100)
        }
    }
}

extension WeeklyTSSController: WeekChangeDelegate {
    func nextWeek() {
        let firstDayLastWeek = Calendar.current.date(byAdding: .day, value: 7, to: firstDateOfWeek!)
        let lastDayLastWeek = Calendar.current.date(byAdding: .day, value: 7, to: lastDateOfWeek!)
        firstDateOfWeek = firstDayLastWeek!
        lastDateOfWeek = lastDayLastWeek!
        filterDataByDate(begin: firstDayLastWeek!, end: lastDayLastWeek!)
    }
    
    func lastWeek() {
        let firstDayLastWeek = Calendar.current.date(byAdding: .day, value: -7, to: firstDateOfWeek!)
        let lastDayLastWeek = Calendar.current.date(byAdding: .day, value: -7, to: lastDateOfWeek!)
        firstDateOfWeek = firstDayLastWeek!
        lastDateOfWeek = lastDayLastWeek!
        filterDataByDate(begin: firstDayLastWeek!, end: lastDayLastWeek!)
    }
}
