//
//  ActivityCell.swift
//  StravaActivityGetter
//
//  Created by Allen Liang on 7/23/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit

class WeeklyActivityCell: UICollectionViewCell {
    
    var weeklyTSSControllerDelegate: WeeklyTSSController?
    var activity: ActivityWithPower? {
        didSet {
            activityNameLabel.text = activity?.name
            if let dateString = activity?.start_date {
                let stringToDate = DateFormatter()
                stringToDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date = stringToDate.date(from: dateString)
                let dateToString = DateFormatter()
                dateToString.dateFormat = "MMM d yyyy, 'at' h:mm a"
                dateLabel.text = dateToString.string(from: date!)
            }
            
            let tss = Analyze.shared.calculateTSS(data: activity?.powerData ?? [1], movingTime: activity?.moving_time ?? 1)
            tssScore.text = "\(Int(tss))"
            
            if let time = activity?.moving_time {
                let (h,m,s) = Utility.shared.secondsToHoursMinutesSeconds(seconds: time)
                if h > 0 {
                    durationLabel.text = "\(h)h \(m)m"
                } else {
                    durationLabel.text = "\(m)m"
                }
                
            }
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let activityIcon: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bike"))
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let dateLabel: UILabel = {
        let lb = UILabel(text: "July 21, 2020 @ 6:51 PM", font: .systemFont(ofSize: 12))
        return lb
    }()
    
    let activityNameLabel: UILabel = {
        let lb = UILabel(text: "Evening Ride", font: .systemFont(ofSize: 16))
        return lb
    }()
    
    let durationLabel: UILabel = {
        let lb = UILabel(text: "1h 5m", font: .systemFont(ofSize: 12))
        lb.textColor = .lightGray
        return lb
    }()
    
    let tssScore: UILabel = {
        let lb = UILabel(text: "45", font: .boldSystemFont(ofSize: 24))
        lb.textAlignment = .center

        return lb
    }()
    
    
    func setupView() {
        addSubview(activityIcon)
        addSubview(tssScore)
        
        let infoStack = VerticalStackView(arrangedSubviews: [dateLabel, activityNameLabel, durationLabel], spacing: 8)
        
        addSubview(infoStack)
        
        activityIcon.anchor(top: infoStack.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 12, bottom: 0, right: 0), size: .init(width: 30, height: 20))
        
        tssScore.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 12), size: .init(width: 50, height: 30))
        tssScore.centerYInSuperview()
        
        infoStack.anchor(top: nil, leading: activityIcon.trailingAnchor, bottom: nil, trailing: tssScore.leadingAnchor, padding: .init(top: 0, left: 18, bottom: 0, right: 8))
        infoStack.centerYInSuperview()
        
        let line = UIView()
        line.backgroundColor = .lightGray
        line.alpha = 0.3
        addSubview(line)
        
        line.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 14, bottom: 0, right: 14))
        line.constrainHeight(constant: 1)
        
        
    }
}
