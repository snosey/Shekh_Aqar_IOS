//
//  CompanyService.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/25/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class CompanyService: DataType {
    
    var nameAr : String!
    var nameEn : String!
    var key: String!
    var id : Int!
    
    var isChecked = false
    
    //MARK: Decodable
    required public init?(json: JSON){
        nameAr = "name_ar" <~~ json
        nameEn = "name_en" <~~ json
        key = "key" <~~ json
        id = "id" <~~ json
    }
    
    public init() {
        
    }
    
    public init(id : Int, nameEn: String, nameAr: String, key: String) {
        self.id = id
        self.nameEn = nameEn
        self.nameAr = nameAr
        self.key = key
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "name_ar" ~~> nameAr,
            "name_en" ~~> nameEn,
            "key" ~~> key,
            "id" ~~> id,
            ])
    }
    
}
