//
//  SummaryView.swift
//  StravaActivityGetter
//
//  Created by Allen Liang on 7/20/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit

protocol WeekChangeDelegate {
    func lastWeek()
    func nextWeek()
}

class SummaryViewCell: UICollectionViewCell {
    
    var weeklyTSSControllerDelegate: WeeklyTSSController?
    var weekChangeDelegate: WeekChangeDelegate!
    var begin: Date!
    var end: Date!
    var currentDate: Date!
    var activities: [ActivityWithPower]? {
        didSet {
            var tssSum = 0
            guard let activities = activities else { return }
            
            if activities.count != 0 {
                titleLabel.text = "Below weekly range"
                bodyLabel.text = "Your activity level has been lighter than average. If you are recovering, try to stay under 200."
            }
            for activity in activities {
                tssSum += activity.tss
            }
            tssLabel.text = "\(tssSum)"
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            var largestTss = 0.0
            for activity in activities {
                let tss = Double(activity.tss)
                if tss > largestTss {
                    largestTss = tss
                }
            }
            
            
            guard let tssBars = tssBars else { return }

            var noActivityDays = [1 : false,
                                  2 : false,
                                  3 : false,
                                  4 : false,
                                  5 : false,
                                  6 : false,
                                  7 : false]
            
            var tssbarHeights = [1 : 0.0,
                                 2 : 0.0,
                                 3 : 0.0,
                                 4 : 0.0,
                                 5 : 0.0,
                                 6 : 0.0,
                                 7 : 0.0]
            for activity in activities {
                let date = df.date(from: activity.start_date)
                let weekday = Calendar.current.component(.weekday, from: date!)
                let tss = Double(activity.tss)
                if tss != 0 {
                    noActivityDays[weekday] = true
                    let height = tss/largestTss * 100
                    tssbarHeights[weekday] = tssbarHeights[weekday]! + height
                }
            }
            for (key, value) in noActivityDays {
                if value == false {
                    tssBars[key - 1].constrainHeight(constant: 2)
                } else {
                    tssBars[key - 1].constrainHeight(constant: CGFloat(tssbarHeights[key]!))
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let weekLabel: UILabel = {
        let lb = UILabel(text: "Jul 26 - Aug 1", font: .systemFont(ofSize: 16))
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var leftButton: UIButton = {
        let button = UIButton(title: "<")
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(lastWeek), for: .touchUpInside)
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton(title: ">")
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(nextWeek), for: .touchUpInside)
        return button
    }()
    
    let tssLabel: UILabel = {
        let lb = UILabel(text: "0", font: .boldSystemFont(ofSize: 70))
        return lb
    }()
    
    @objc func showTSSInfo() {
        let navController = UINavigationController(rootViewController: TSSInfo())
        navController.modalPresentationStyle = .fullScreen
        weeklyTSSControllerDelegate?.present(navController, animated: true, completion: nil)
    }
    
    lazy var tssInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.addTarget(self, action: #selector(showTSSInfo), for: .touchUpInside)
        return button
    }()
    
    let titleLabel: UILabel = {
        let lb = UILabel(text: "No heart rate activities", font: .boldSystemFont(ofSize: 24))
        return lb
    }()
    
    let bodyLabel: UILabel = {
        let lb = UILabel(text: "Upload a workout to start your week", font: .systemFont(ofSize: 14))
        lb.numberOfLines = 3
        return lb
    }()
    
    @objc func lastWeek() {
        weekChangeDelegate.lastWeek()
        for bar in tssBars! {
            bar.removeConstraints(bar.constraints)
        }
        let newDate = Calendar.current.date(byAdding: .day, value: -7, to: currentDate)
        currentDate = newDate
        let (firstDateOfWeek, lastDateOfWeek) = getWeekRange(date:currentDate)
        let df = DateFormatter()
        df.dateFormat = "MMM d"
        let b = df.string(from: firstDateOfWeek)
        let e = df.string(from: lastDateOfWeek)
        weekLabel.text = b + " - " + e
        
        
    }
    
    @objc func nextWeek() {
        weekChangeDelegate.nextWeek()
        for bar in tssBars! {
            bar.removeConstraints(bar.constraints)
        }
        let newDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)
        currentDate = newDate
        let (firstDateOfWeek, lastDateOfWeek) = getWeekRange(date:currentDate)
        let df = DateFormatter()
        df.dateFormat = "MMM d"
        let b = df.string(from: firstDateOfWeek)
        let e = df.string(from: lastDateOfWeek)
        weekLabel.text = b + " - " + e
    }
    
    
    
    var tssBars: [UIView]?
    
    func setupView(){
        addSubview(tssLabel)
        addSubview(tssInfoButton)
        
        let bodyStack = VerticalStackView(arrangedSubviews: [titleLabel, bodyLabel], spacing: 8)
        let weekRangeStack = UIStackView(arrangedSubviews: [leftButton, weekLabel, rightButton], customSpacing: 0)
        weekRangeStack.distribution = .fillEqually
        addSubview(bodyStack)
        addSubview(weekRangeStack)
        
        weekRangeStack.centerXInSuperview()
        weekRangeStack.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 28, left: 0, bottom: 0, right: 0))
        
        tssLabel.anchor(top: weekLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 24, bottom: 0, right: 0))
        
        tssInfoButton.anchor(top: tssLabel.topAnchor, leading: tssLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 14, bottom: 0, right: 0))
        
        bodyStack.anchor(top: tssLabel.bottomAnchor, leading: tssLabel.leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 24))
        
        let days = ["S", "M", "T", "W", "T", "F", "S"]
        var dayLabels = [UILabel]()
        
        for i in 0..<days.count {
            let lb = UILabel(text: days[i], font: .systemFont(ofSize: 14))
            lb.textAlignment = .center
            lb.constrainWidth(constant: 14)
            dayLabels.append(lb)
        }
        let weekStack = UIStackView(arrangedSubviews: dayLabels, customSpacing: 16)
        
        addSubview(weekStack)
        
        weekStack.anchor(top: bodyStack.bottomAnchor, leading: bodyStack.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 140, left: 0, bottom: 0, right: 0))
        
        var dayTSSBarViews = [UIView]()
        
        for i in 0..<days.count {
            let tssBar = UIView()
            dayTSSBarViews.append(tssBar)
            tssBar.backgroundColor = .black
            addSubview(tssBar)
            tssBar.anchor(top: nil, leading: dayLabels[i].leadingAnchor, bottom: dayLabels[i].topAnchor, trailing: dayLabels[i].trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 0))
        }
        
        tssBars = dayTSSBarViews
        
        let line = UIView()
        line.backgroundColor = .lightGray
        line.alpha = 0.3
        addSubview(line)
        line.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        line.constrainHeight(constant: 1)
        
        currentDate = Date()
        let (firstDateOfWeek, lastDateOfWeek) = getWeekRange(date:currentDate)
        let df = DateFormatter()
        df.dateFormat = "MMM d"
        let b = df.string(from: firstDateOfWeek)
        let e = df.string(from: lastDateOfWeek)
        weekLabel.text = b + " - " + e
    }
    
    
    
}
