//
//  SegmentCell.swift
//  StravaActivityGetter
//
//  Created by Allen Liang on 8/11/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit

class SegmentCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "segmentCellId")
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let segmentLabel: UILabel = {
        let lb = UILabel(text: "segment", font: .systemFont(ofSize: 14))
        return lb
    }()
    
    let infoLabel: UILabel = {
        let lb = UILabel(text: "0.8 mi - 416ft - 9%", font: .systemFont(ofSize: 12))
        lb.textColor = .lightGray
        return lb
    }()
    
//    let elevationLabel: UILabel = {
//        let lb = UILabel(text: "segment", font: .systemFont(ofSize: 16))
//        return lb
//    }()
//
//    let gradeLabel: UILabel = {
//        let lb = UILabel(text: "segment", font: .systemFont(ofSize: 16))
//        return lb
//    }()
    
    func setupView() {
        let segmentStack = VerticalStackView(arrangedSubviews: [segmentLabel, infoLabel], spacing: 0)
        segmentStack.distribution = .fillEqually
        addSubview(segmentStack)
        segmentStack.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 24, bottom: 8, right: 16))
        segmentStack.centerYInSuperview()
    }
}
