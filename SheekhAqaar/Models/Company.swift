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
    var nameAr : String!
    var nameEn : String!
    var addressEn : String!
    var addressAr : String!
    var phoneNumber: String!
    var latitude: Double!
    var longitude: Double!
    var numberOfAds: Int!
    var imageUrl: String!
    var colorCode : String!
    var companyServices: [CompanyService]!
    
    //MARK: Decodable
    required public init?(json: JSON){
        nameAr = "name_ar" <~~ json
        nameEn = "name_en" <~~ json
        addressAr = "address_ar" <~~ json
        addressEn = "address_en" <~~ json
        phoneNumber = "phone_number" <~~ json
        latitude = "latitude" <~~ json
        longitude = "longitude" <~~ json
        numberOfAds = "ads_number" <~~ json
        imageUrl = "image_url" <~~ json
        id = "id" <~~ json
        colorCode = "color_code" <~~ json
        companyServices = "services" <~~ json
    }
    
    public init() {
        
    }
    
    public init(id : Int, nameEn: String, nameAr: String, addressEn: String, addressAr: String, phoneNumber: String, latitude: Double, longitude: Double, numberOfAds: Int, imageUrl: String, colorCode: String, companyServices: [CompanyService]) {
        self.id = id
        self.nameEn = nameEn
        self.nameAr = nameAr
        self.addressEn = addressEn
        self.addressAr = addressAr
        self.phoneNumber = phoneNumber
        self.latitude = latitude
        self.longitude = longitude
        self.numberOfAds = numberOfAds
        self.imageUrl = imageUrl
        self.colorCode = colorCode
        self.companyServices = companyServices
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "name_ar" ~~> nameAr,
            "name_en" ~~> nameEn,
            "address_ar" ~~> addressEn,
            "address_en" ~~> addressAr,
            "phone_number" ~~> phoneNumber,
            "latitude" ~~> latitude,
            "longitude" ~~> longitude,
            "ads_number" ~~> numberOfAds,
            "image_url" ~~> imageUrl,
            "id" ~~> id,
            "color_code" ~~> colorCode,
            "services" ~~> companyServices,
            ])
    }
    
}
