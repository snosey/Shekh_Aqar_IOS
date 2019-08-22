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
    
    var nameAr : String!
    var nameEn : String!
    var id : Int!
    var regions: [Region]!
    
    //MARK: Decodable
    required public init?(json: JSON){
        nameAr = "name_ar" <~~ json
        nameEn = "name_en" <~~ json
        id = "id" <~~ json
        regions = "regions" <~~ json
    }
    
    public init() {
        
    }
    
    public init(id : Int, nameEn: String, nameAr: String, regions: [Region]) {
        self.id = id
        self.nameEn = nameEn
        self.nameAr = nameAr
        self.regions = regions
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "name_ar" ~~> nameAr,
            "name_en" ~~> nameEn,
            "id" ~~> id,
            "regions" ~~> regions,
            ])
    }
    
}
