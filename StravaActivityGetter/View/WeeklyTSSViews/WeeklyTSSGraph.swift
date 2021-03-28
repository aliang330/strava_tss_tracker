//
//  WeeklyTSSGraph.swift
//  StravaActivityGetter
//
//  Created by Allen Liang on 7/23/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit

class WeeklyTSSGraph: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .red
    }
}
