//
//  DefaultsKeys.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/17/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let user = DefaultsKey<Dictionary<String, Any>?>("user")
    static let status = DefaultsKey<Dictionary<String, Any>?>("status")
    static let fcmToken = DefaultsKey<String?>("fcm_token")
    static let token = DefaultsKey<String?>("token")
    static let isLoggedIn = DefaultsKey<Bool?>("isLoggedIn")
    static let notVerifiedUserId = DefaultsKey<String?>("notVerifiedUserId")
    static let hasTrip = DefaultsKey<Bool?>("hasTrip")
    static let lastLoggedInUserId = DefaultsKey<String?>("lastLoggedInUserId")
}
