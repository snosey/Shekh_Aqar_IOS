//
//  AdditionalFacility.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/26/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class AdditionalFacility: DataType {
    
    var name : String!
    var id : Int!
    var itemFeatureModel: ItemFeatureModel!
    
    var isChecked = false
    
    //MARK: Decodable
    required public init?(json: JSON){
        name = "Name" <~~ json
        id = "Id" <~~ json
        itemFeatureModel = "ItemFeatureModel" <~~ json
    }
    
    public init() {
        
    }
    
    public init(id : Int, nameEn: String, nameAr: String) {
        self.id = id
        self.name = nameAr
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "Name" ~~> name,
            "FK_ItemFeature" ~~> id,
            "ItemFeatureModel" ~~> itemFeatureModel,
            ])
    }
    
}
