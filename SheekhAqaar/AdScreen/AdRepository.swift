//
//  AdRepository.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/30/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Alamofire

public protocol AdPresenterDelegate: class {
    func saveFavouriteAdSuccess()
    func removeFavouriteAdSuccess()
    func failed(errorMessage: String)
}


public class AdRepository {
    var delegate: AdPresenterDelegate!
    
    public func setDelegate(delegate: AdPresenterDelegate) {
        self.delegate = delegate
    }
    
    public func saveFavouriteAd(ad: Ad) {
       self.delegate.saveFavouriteAdSuccess()
    }
    
    public func removeFavouriteAd(ad: Ad) {
        self.delegate.removeFavouriteAdSuccess()
    }
}
