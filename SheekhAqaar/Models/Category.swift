//
//  Category.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/24/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class Category: DataType {
    
    var name : String!
    var id : Int!
    var companies: [Company]!
    var ads: [Ad]!
    
    var isClicked = false
    
    //MARK: Decodable
    required public init?(json: JSON){
        name = "Name" <~~ json
        id = "id" <~~ json
        companies = "CompanyTypesModel" <~~ json
        ads = "ads" <~~ json
    }
    
    public init() {
        
    }
    
    public init(id : Int, nameEn: String, nameAr: String, key: String, companies: [Company]) {
        self.id = id
//        self.nameEn = nameEn
//        self.nameAr = nameAr
        self.name = nameEn
//        self.key = key
        self.companies = companies
    }
    
    public init(id : Int, nameEn: String, nameAr: String, key: String, ads: [Ad]) {
        self.id = id
//        self.nameEn = nameEn
        self.name = nameEn
//        self.key = key
        self.ads = ads
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "Name" ~~> name,
            "id" ~~> id,
            "CompanyTypesModel" ~~> companies,
            "ads" ~~> ads,
            ])
    }
    
}
