//
//  TestController.swift
//  StravaActivityGetter
//
//  Created by Allen Liang on 8/13/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit

class TestController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let semaphore = DispatchSemaphore(value: 1)
        let backgroundQueue = DispatchQueue(label: "requests")
        
        backgroundQueue.async {
            semaphore.wait()
            print("task 1 start")
            Service.shared.migrateData {
                print("task 1 end")
                semaphore.signal()
            }
            
            semaphore.wait()
            print("task 2 start")
            Service.shared.fetchedAndSaveStarredSegments { (_) in
                print("task 2 end")
                semaphore.signal()
            }
            
            semaphore.wait()
            Database.shared.saveStarredSegmentEfforts {
                semaphore.signal()
            }
            
        }
    }
}
