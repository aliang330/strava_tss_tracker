//
//  Authorization.swift
//  StravaActivityGetter
//
//  Created by Allen on 6/20/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import Foundation

struct Authorization: Codable {
    let access_token: String?
    let refresh_token: String?
}
