//
//  GrabAllEffortsForSegment.swift
//  StravaActivityGetter
//
//  Created by Allen on 5/27/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit

class GrabAllEffortsForSegment: BaseListController {
    
    let cellId = "cellId"
    let activities = [Activity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(ActivityCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
}

extension GrabAllEffortsForSegment: UICollectionViewDelegateFlowLayout {
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
