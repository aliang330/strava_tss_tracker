////
////  SegmentEfforts.swift
////  StravaActivityGetter
////
////  Created by Allen Liang on 8/13/20.
////  Copyright © 2020 Allen. All rights reserved.
////
//
//import UIKit
//
//class SegmentEffortsController: UITableViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    func getSegmentEfforts() {
//
//    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SegmentCell
//        cell.segmentLabel.text = segments[indexPath.row].name
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
//}
