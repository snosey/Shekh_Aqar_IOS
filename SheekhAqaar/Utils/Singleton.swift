//
//  Singleton.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/17/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import CoreLocation

public class Singleton {
    
    static var instance: Singleton!
    public var currentLocation: CLLocation!
    public var signUpData: SignUpData!
    
    public class func getInstance() -> Singleton {
        if instance ==  nil {
            instance = Singleton()
        }
        return instance
    }
}
