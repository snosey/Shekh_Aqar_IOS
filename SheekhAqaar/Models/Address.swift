//
//  Address.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 10/8/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation

public class Address {
    
    public var addressId: String!
    public var addressName: String!
    public var addressCityName: String!
    public var latitude: Double!
    public var longitude: Double!
    
    public init() {
        
    }
    
    public init(addressId: String, addressName: String, addressCityName: String, latitude: Double, longitude: Double) {
        self.addressId = addressId
        self.addressName = addressName
        self.addressCityName = addressCityName
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
