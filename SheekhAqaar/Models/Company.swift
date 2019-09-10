//
//  Company.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/24/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class Company: DataType {
    
    var id : Int!
    var name : String!
    var userId: Int!
    var imageUrl: String!
    var commercialNumber: Int!
    var regionId: Int!
    var address : String!
    var latitude: String!
    var longitude: String!
    var email: String!
    var phoneNumber: String!
    var numberOfAds: Int!
    
    //MARK: Decodable
    required public init?(json: JSON){
        id = "Id" <~~ json
        name = "Name" <~~ json
        userId = "Fk_User" <~~ json
        imageUrl = "Logo" <~~ json
        commercialNumber = "CommercialNumber" <~~ json
        regionId = "Fk_Location" <~~ json
        address = "Address" <~~ json
        numberOfAds = "AdsCount" <~~ json
        latitude = "Latitude" <~~ json
        longitude = "Longitude" <~~ json
        phoneNumber = "Phone" <~~ json
        email = "Email" <~~ json
    }
    
    public init() {
        
    }
    
    public init(id : Int, nameEn: String, nameAr: String, addressEn: String, addressAr: String, phoneNumber: String, latitude: Double, longitude: Double, numberOfAds: Int, imageUrl: String, colorCode: String, companyServices: [CompanyService]) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.numberOfAds = numberOfAds
        self.imageUrl = imageUrl
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "Id" ~~> id,
            "name" ~~> name,
            "Fk_User" ~~> userId,
            "Logo" ~~> imageUrl,
            "CommercialNumber" ~~> commercialNumber,
            "Fk_Location" ~~> regionId,
            "Address" ~~> address,
            "AdsCount" ~~> numberOfAds,
            "Latitude" ~~> latitude,
            "Longitude" ~~> longitude,
            "Phone" ~~> phoneNumber,
            "Email" ~~> email,
            ])
    }
    
}
