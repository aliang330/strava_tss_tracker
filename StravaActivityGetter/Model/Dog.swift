//
//  Dog.swift
//  StravaActivityGetter
//
//  Created by Allen on 5/30/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import Foundation
import RealmSwift

class Dog: Object {
    @objc dynamic var name: String?
    @objc dynamic var age = 0
    @objc dynamic var color: String?
}
