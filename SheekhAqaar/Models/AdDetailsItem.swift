//
//  AdDetailsItem.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/23/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class AdDetailsItem: DataType {
    var id : Int!
    var name: String!
    var value: Int!
    var spinnerDataArray: [SpinnerData]!
    var imageUrl: String!
    var dataSpinnerFK: Int!
    var typeDataFK: Int!
    var userItemFK: Int!
    
    //MARK: Decodable
    required public init?(json: JSON){
        id = "Id" <~~ json
        name = "Name" <~~ json
        value = "Value" <~~ json
        imageUrl = "ImgURL" <~~ json
        spinnerDataArray = "DataSpinnerModel" <~~ json
        dataSpinnerFK = "Fk_DataSpinner" <~~ json
        typeDataFK = "Fk_TypeData" <~~ json
        userItemFK = "Fk_UserItem" <~~ json
    }
    
    public init() {
        
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "Fk_ItemMain" ~~> id,
            "Name" ~~> name,
            "Value" ~~> value,
            "ImgURL" ~~> imageUrl,
            "DataSpinnerModel" ~~> spinnerDataArray,
            "Fk_DataSpinner" ~~> (dataSpinnerFK ?? 0),
            "Fk_TypeData" ~~> typeDataFK,
            "Fk_UserItem" ~~> (userItemFK ?? 0),
            ])
    }
}
