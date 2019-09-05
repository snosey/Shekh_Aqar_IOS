//
//  Country.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/22/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class Country: DataType {
    
    var id : Int!
    var name : String!
    var shortName : String!
    var code: String!
    var imageUrl: String!
    var timeZoneId: Int!
    var currencyId: Int!
    var timeZone: CountryTimeZone!
    var currency: Currency!
    var regions: [Region]!
    
    //MARK: Decodable
    required public init?(json: JSON){
        id = "Id" <~~ json
        name = "Name" <~~ json
        shortName = "ShortName" <~~ json
        code = "Code" <~~ json
        imageUrl = "ImgURL" <~~ json
        timeZoneId = "FK_TimZone" <~~ json
        currencyId = "FK_Currency" <~~ json
        timeZone = "TimZone" <~~ json
        currency = "Currency" <~~ json
        regions = "LocationsModel" <~~ json
    }
    
    public init() {
        
    }
    
    public init(id : Int, nameEn: String, nameAr: String, regions: [Region]) {
        self.id = id
//        self.nameEn = nameEn
//        self.nameAr = nameAr
        self.regions = regions
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "Id" ~~> id,
            "Name" ~~> name,
            "ShortName" ~~> shortName,
            "Code" ~~> code,
            "ImgURL" ~~> imageUrl,
            "FK_TimZone" ~~> timeZoneId,
            "FK_Currency" ~~> currencyId,
            "TimZone" ~~> timeZone,
            "Currency" ~~> currency,
            "LocationsModel" ~~> regions,
            ])
    }
    
}
