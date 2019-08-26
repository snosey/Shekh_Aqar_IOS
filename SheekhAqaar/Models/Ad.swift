//
//  Ad.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/26/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class Ad: DataType {
    
    var id: Int!
    var name : String!
    var imagesUrls : [String]!
    var price: String!
    var currency: Currency!
    var details: String!
    var category: Category!
    var adType: AdType!
    var placeArea: Double!
    var country: Country!
    var region: Region!
    var detailedAddress: String!
    var latitude: Double!
    var longitude: Double!
    var farshLevel: FarshLevel!
    var roomsNumber: Int!
    var bathRoomsNumber: Int!
    var additionalFacilities: [AdditionalFacility]!
    
    //MARK: Decodable
    required public init?(json: JSON){
        id = "id" <~~ json
        name = "name" <~~ json
        imagesUrls = "imagesUrls" <~~ json
        price = "price" <~~ json
        currency = "currency" <~~ json
        details = "details" <~~ json
        category = "category" <~~ json
        adType = "adType" <~~ json
        country = "country" <~~ json
        region = "region" <~~ json
        detailedAddress = "detailedAddress" <~~ json
        latitude = "latitude" <~~ json
        longitude = "longitude" <~~ json
        farshLevel = "farshLevel" <~~ json
        roomsNumber = "roomsNumber" <~~ json
        bathRoomsNumber = "bathRoomsNumber" <~~ json
        additionalFacilities = "additionalFacilities" <~~ json
    }
    
    public init() {
        
    }
    
    public init(id: Int, name: String, imagesUrls: [String], price: String, currency: Currency, details: String, category: Category, adType: AdType, country: Country, region: Region, detailedAddress: String, latitude: Double, longitude: Double, farshLevel: FarshLevel, roomsNumber: Int, bathRoomsNumber: Int, additionalFacilities: [AdditionalFacility]) {
        self.id = id
        self.name = name
        self.imagesUrls = imagesUrls
        self.price = price
        self.currency = currency
        self.details = details
        self.category = category
        self.adType = adType
        self.country = country
        self.region = region
        self.detailedAddress = detailedAddress
        self.latitude = latitude
        self.longitude = longitude
        self.farshLevel = farshLevel
        self.roomsNumber = roomsNumber
        self.bathRoomsNumber = bathRoomsNumber
        self.additionalFacilities = additionalFacilities
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "id" ~~> id,
            "name" ~~> name,
            "imagesUrls" ~~> imagesUrls,
            "price" ~~> price,
            "currency" ~~> currency,
            "details" ~~> details,
            "category" ~~> category,
            "adType" ~~> adType,
            "country" ~~> country,
            "region" ~~> region,
            "detailedAddress" ~~> detailedAddress,
            "latitude" ~~> latitude,
            "longitude" ~~> longitude,
            "farshLevel" ~~> farshLevel,
            "roomsNumber" ~~> roomsNumber,
            "bathRoomsNumber" ~~> bathRoomsNumber,
            "additionalFacilities" ~~> additionalFacilities,
            ])
    }
    
}
