//
//  HomeScreen.swift
//  StravaActivityGetter
//
//  Created by Allen on 6/8/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit


let CODE_NOTICATION_KEY = "com.allen.code"

class HomeScreen: UIViewController {
    
    let name = Notification.Name(rawValue: CODE_NOTICATION_KEY)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(getAccessToken), name: name, object: nil)
    }
    
    let loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(handleAuthentication), for: .touchUpInside)
        button.setImage(UIImage(named: "strava"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    
    @objc func handleAuthentication() {
        let clientId = 00000
        let callBackUrl = "appid://127.0.0.1"
        let scope = "activity:read"
        let OAuthUrlStrvaScheme = URL(string: "strava://oauth/mobile/authorize?client_id=\(clientId)&redirect_uri=\(callBackUrl)&response_type=code&approval_prompt=auto&scope=\(scope)")!
        
        let application = UIApplication.shared
        
        if application.canOpenURL(OAuthUrlStrvaScheme) {
            application.open(OAuthUrlStrvaScheme, options: [:]) { (bool) in
                print("success")
            }
        } else {
            print("error opening strava")
        }
    }
    
    func setupView() {
        view.addSubview(loginButton)
        loginButton.centerInSuperview()
        loginButton.constrainHeight(constant: 60)
    }
    
    @objc func getAccessToken() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        Service.shared.getAccessToken { (error) in
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
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
          
                
                print("task 3 start")
                let ids = Database.shared.getAllActivityIds()
                print(ids.count)
                
                for id in ids {
                    semaphore.wait()
                    print(id)
                    Service.shared.fetchHeartRateStreamNotInDatabaseAndSave(for: id) {
                        semaphore.signal()
                    }
                }
                
                print("task 3 end")
                    
                    
                
                DispatchQueue.main.async {
                    let tabController = TabBarController()
                    tabController.modalPresentationStyle = .fullScreen
                    self.present(tabController, animated: true, completion: nil)
                }
            }
//            let testVC = TestController()
//            testVC.modalPresentationStyle = .fullScreen
//            self.present(testVC, animated: true, completion: nil)
        }
    }
}
