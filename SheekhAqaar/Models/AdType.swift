//
//  AdType.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/26/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class AdType: DataType {
    
    var nameAr : String!
    var nameEn : String!
    var id : Int!
    
    //MARK: Decodable
    required public init?(json: JSON){
        nameAr = "name_ar" <~~ json
        nameEn = "name_en" <~~ json
        id = "id" <~~ json
    }
    
    public init() {
        
    }
    
    public init(id : Int, nameEn: String, nameAr: String) {
        self.id = id
        self.nameEn = nameEn
        self.nameAr = nameAr
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "name_ar" ~~> nameAr,
            "name_en" ~~> nameEn,
            "id" ~~> id,
            ])
    }
    
}
