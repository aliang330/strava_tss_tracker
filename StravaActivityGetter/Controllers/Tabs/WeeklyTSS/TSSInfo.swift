//
//  TSSInfo.swift
//  StravaActivityGetter
//
//  Created by Allen Liang on 7/21/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit

class TSSInfo: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    let titleLabel: UILabel = {
        let lb = UILabel(text: "Training Stress Score", font: .boldSystemFont(ofSize: 28))
        return lb
    }()
    
    let subtitleLabel: UILabel = {
        let lb = UILabel(text: "What is Training Stress Score (TSS)?", font: .boldSystemFont(ofSize: 18))
        return lb
    }()
    
    let bodyTV: UITextView = {
        let tv = UITextView()
        tv.text = "Training Stress Score (TSS) is a composite number that takes into account the duration and intensity of a workout to arrive at a single estimate of the overall training load and physiological stress created by that training session."
        tv.font = UIFont(name: "Helvetica", size: 16)
        tv.textColor = .black
        tv.isScrollEnabled = false
        return tv
    }()
    
    func setupView() {
        setupNavBar()
        view.backgroundColor = .white
        
        let infoStack = VerticalStackView(arrangedSubviews: [titleLabel, subtitleLabel, bodyTV], spacing: 16)
        view.addSubview(infoStack)
        
        infoStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
    }
    
    func setupNavBar() {
        navigationItem.title = "Training Stress Score"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 17)]
        
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .plain, target: self, action: #selector(dimissViewController))
        
        navigationItem.leftBarButtonItem = cancelButton
        
        view.backgroundColor = .red
    }
    
    @objc func dimissViewController() {
        dismiss(animated: true, completion: nil)
    }
}
