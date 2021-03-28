//
//  MySegmentsController.swift
//  StravaActivityGetter
//
//  Created by Allen Liang on 8/8/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit

class MySegmentsController: UITableViewController {
    
    let cellId = "segmentCellId"
    var segments = [Segment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(SegmentCell.self, forCellReuseIdentifier: cellId)
        getSegments()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        getSegments()
//    }
    
    func getSegments() {
        segments = Database.shared.getSegments()
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SegmentCell
        cell.segmentLabel.text = segments[indexPath.row].name
        
        cell.infoLabel.text = ""
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
