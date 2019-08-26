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
    
    var nameAr : String!
    var nameEn : String!
    var key: String!
    var id : Int!
    var companies: [Company]!
    var ads: [Ad]!
    
    var isClicked = false
    
    //MARK: Decodable
    required public init?(json: JSON){
        nameAr = "name_ar" <~~ json
        nameEn = "name_en" <~~ json
        key = "key" <~~ json
        id = "id" <~~ json
        companies = "companies" <~~ json
        ads = "ads" <~~ json
    }
    
    public init() {
        
    }
    
    public init(id : Int, nameEn: String, nameAr: String, key: String, companies: [Company]) {
        self.id = id
        self.nameEn = nameEn
        self.nameAr = nameAr
        self.key = key
        self.companies = companies
    }
    
    public init(id : Int, nameEn: String, nameAr: String, key: String, ads: [Ad]) {
        self.id = id
        self.nameEn = nameEn
        self.nameAr = nameAr
        self.key = key
        self.ads = ads
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "name_ar" ~~> nameAr,
            "name_en" ~~> nameEn,
            "key" ~~> key,
            "id" ~~> id,
            "companies" ~~> companies,
            "ads" ~~> ads,
            ])
    }
    
}
