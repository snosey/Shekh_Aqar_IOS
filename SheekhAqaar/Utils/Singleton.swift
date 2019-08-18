//
//  Singleton.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/17/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
public class Singleton {
    
    static var instance: Singleton!
    
    public class func getInstance() -> Singleton {
        if instance ==  nil {
            instance = Singleton()
        }
        return instance
    }
}
