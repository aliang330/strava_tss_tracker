//
//  ActivityCell.swift
//  StravaActivityGetter
//
//  Created by Allen on 5/24/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit

class ActivityCell: UICollectionViewCell {
    
    var activity: Activity? {
        didSet {
            if let name = activity?.name {
                nameLabel.text = "Name: \(name)"
            }
            if let distance = activity?.distance {
                let distanceInMiles = String(format: "%.2f", distance/1600)
                distanceLabel.text = "Distance: " + distanceInMiles + " mi"
            }
            if let time = activity?.elapsed_time {
                let (h,m,s) = Utility.shared.secondsToHoursMinutesSeconds(seconds: time)
                timeLabel.text = "Time: \(h)h \(m)m"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    let nameLabel = UILabel(text: "activity name", font: .systemFont(ofSize: 20))
    let distanceLabel = UILabel(text: "20 mi", font: .systemFont(ofSize: 18))
    let timeLabel = UILabel(text: "1h 23m", font: .systemFont(ofSize: 18))
    
    func setupView() {
        
        
        let stack = VerticalStackView(arrangedSubviews: [nameLabel, distanceLabel, timeLabel], spacing: 8)
        
        addSubview(stack)
        stack.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
