//
//  Currency.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/26/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class Currency: DataType {
    
    var name : String!
    var shortName: String!
    var valueToEG: Int!
    var id : Int!
    
    //MARK: Decodable
    required public init?(json: JSON){
        name = "Name" <~~ json
        shortName = "ShortName" <~~ json
        valueToEG = "VtoEg" <~~ json
        id = "Id" <~~ json
    }
    
    public init() {
        
    }
    
    public init(id : Int, nameEn: String, nameAr: String) {
        self.id = id
        self.name = nameEn
//        self.nameAr = nameAr
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "ShortName" ~~> shortName,
            "VtoEg" ~~> valueToEG,
            "Name" ~~> name,
            "Id" ~~> id,
            ])
    }
    
}
