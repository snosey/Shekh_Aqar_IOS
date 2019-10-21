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
    var hexCode: String!
    var mainCategoryId: Int!
    var subCategories: [Category]!
    
    var isClicked = false
    
    //MARK: Decodable
    required public init?(json: JSON){
        name = "Name" <~~ json
        id = "Id" <~~ json
        hexCode = "HexColor" <~~ json
        mainCategoryId = "Fk_MainCategory" <~~ json
    }
    
    public init() {
        
    }
    
    public init(id : Int, nameEn: String, nameAr: String, key: String, companies: [Company]) {
        self.id = id
        self.name = nameEn
    }
    
    public init(id : Int, nameEn: String, nameAr: String, key: String, ads: [Ad]) {
        self.id = id
        self.name = nameEn
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "Name" ~~> name,
            "Id" ~~> id,
            "HexColor" ~~> hexCode,
            "Fk_MainCategory" ~~> mainCategoryId,
            ])
    }
    
}
