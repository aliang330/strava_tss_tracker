//
//  ViewController.swift
//  StravaActivityGetter
//
//  Created by Allen on 5/24/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit


class ViewController: BaseListController {

    let cellId = "cellId"
    var activities = [Activity]()
    let segmentName = "Blue Hills Access Road (full)"
    var db: SQLiteDatabase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(ActivityCell.self, forCellWithReuseIdentifier: cellId)
//        getSegmentEfforts()
        
        
//        do {
//            db = try SQLiteDatabase.open(path: DATABASE_PATH)
//            print("\nopened connection to database.")
//        } catch SQLiteError.OpenDatabase(_) {
//            print("\nunable to connect to database.")
//        } catch {
//            print(error)
//        }
//
//        db?.deleteTable(deleteStatementString: "DROP TABLE Activity;")
////        create Activity Table, commented out because it is already created
//        guard db != nil else { return }
//        do {
//            try db?.createTable(table: Activity.self)
//        } catch {
//            print("Error creating table, ", error)
//        }
//        storeFetchedActivities()
    }
    
//    func storeFetchedActivities() {
//        var activities = [Activity]()
//        let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
//        Service.shared.fetchActivities { (fetchedActivities, error) in
//            dispatchGroup.leave()
//            if error != nil {
//                print("error fetching activities.", error)
//            }
//            if fetchedActivities != nil {
//                activities = fetchedActivities!
//            }
//
//        }
//        dispatchGroup.notify(queue: .main) {
//            print(activities)
//            for i in 0..<activities.count {
//                do {
//                    try self.db?.insertActivity(activity: activities[i])
//                } catch {
//                    print("error inserting Activity into Activity table. ", error)
//                }
//            }
//
//        }
//    }

//    func getSegmentEfforts() {
//        var activities = [Activity]()
//        var detailedActivities = [Activity]()
//        var activityIds = [Int]()
//        let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
//        Service.shared.fetchActivities { (fetchedActivities, error) in
//            dispatchGroup.leave()
//            if error != nil {
//                print(error!)
//            }
//            if fetchedActivities != nil {
//                activities = fetchedActivities!
//            }
//        }
//        dispatchGroup.notify(queue: .main) {
//
//            print(activities)
//
//
//            for i in 0..<activities.count {
//                activityIds.append(activities[i].id)
//
//                for i in 0...activityIds.count - 1 {
//                    dispatchGroup.enter()
//                    Service.shared.getDetailedActivity(id: "\(activityIds[i])") { (detailedActivity, error) in
//                        dispatchGroup.leave()
//                        if error != nil {
//                            print(error!)
//                            return
//                        }
//                        guard let detailedActivity = detailedActivity else { return }
//                        detailedActivities.append(detailedActivity)
//                    }
//                }
//                dispatchGroup.notify(queue: .main) {
//                    print(detailedActivities.count)
//                    self.extractSegmentEffortsFromDetailedActivity(activities: detailedActivities)
//                }
//            }
//        }
//    }
//
//    func extractSegmentEffortsFromDetailedActivity(activities: [Activity]) {
//        var segmentTimes = [Int]()
//
//        for i in 0..<activities.count {
//            if let efforts = activities[i].segment_efforts {
//                for j in 0..<efforts.count {
//                    if efforts[j].name == segmentName {
//                        segmentTimes.append(efforts[j].elapsed_time)
//                    }
//                }
//            }
//        }
//        print(segmentTimes)
//    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ActivityCell
        cell.activity = activities[indexPath.item]
        cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 120)
    }
}
