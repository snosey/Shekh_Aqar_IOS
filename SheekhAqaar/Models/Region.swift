//
//  Region.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/22/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class Region: DataType {
    
    var id : Int!
    var name: String!
    var countryId: Int!
    var latitude: String!
    var longitude: String!
    var country: Country!
    var companies: [Company]!
    
    //MARK: Decodable
    required public init?(json: JSON){
        id = "Id" <~~ json
        name = "Name" <~~ json
        countryId = "FK_Country" <~~ json
        latitude = "Latitude" <~~ json
        longitude = "Longitude" <~~ json
        country = "CountryModel" <~~ json
        companies = "CompaniesModel" <~~ json
    }
    
    public init() {
        
    }
    
    public init(id : Int, nameEn: String, nameAr: String) {
        self.id = id
//        self.nameEn = nameEn
//        self.nameAr = nameAr
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "Id" ~~> id,
            "Name" ~~> name,
            "FK_Country" ~~> countryId,
            "Latitude" ~~> latitude,
            "Longitude" ~~> longitude,
            "CountryModel" ~~> country,
            "CompaniesModel" ~~> companies,
            ])
    }
    
}
