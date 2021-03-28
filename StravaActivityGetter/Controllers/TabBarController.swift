//
//  TabController.swift
//  StravaActivityGetter
//
//  Created by Allen Liang on 8/11/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [createNavController(viewController: WeeklyTSSController(), title: "Home", imageName: "house"), createNavController(viewController: MySegmentsController(), title: "Segments", imageName: "clock")]
        
    }
    
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        viewController.view.backgroundColor = .white
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: imageName)
        viewController.navigationItem.title = title
        
        return navController
    }
}
