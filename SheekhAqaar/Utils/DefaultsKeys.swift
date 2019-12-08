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
    static let company = DefaultsKey<Dictionary<String, Any>?>("company")
    static let fcmToken = DefaultsKey<String?>("fcm_token")
    static let token = DefaultsKey<String?>("token")
    static let isLoggedIn = DefaultsKey<Bool?>("isLoggedIn")
    static let isSkipped = DefaultsKey<Bool?>("isSkipped")
    static let notVerifiedUserId = DefaultsKey<String?>("notVerifiedUserId")
    static let hasTrip = DefaultsKey<Bool?>("hasTrip")
    static let lastLoggedInUserId = DefaultsKey<String?>("lastLoggedInUserId")
    static let authVerificationID = DefaultsKey<String?>("authVerificationID")
    static let choosenMapType =  DefaultsKey<Int?>("choosenMapType")
}
