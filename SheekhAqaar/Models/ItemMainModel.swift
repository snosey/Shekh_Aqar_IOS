//
//  ItemMainModel.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 10/2/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class ItemMainModel: DataType {
    var id : Int!
    var name: String!
    var value: Int!
    var spinnerData: SpinnerData!
    var imageUrl: String!
    var adDetailsItem: AdDetailsItem!
    
    //MARK: Decodable
    required public init?(json: JSON){
        id = "Id" <~~ json
        name = "Name" <~~ json
        value = "Value" <~~ json
        imageUrl = "ImgURL" <~~ json
        spinnerData = "DataSpinnerModel" <~~ json
        adDetailsItem = "ItemMainModel" <~~ json
    }
    
    public init() {
        
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "Id" ~~> id,
            "Name" ~~> name,
            "Value" ~~> value,
            "ImgURL" ~~> imageUrl,
            "DataSpinnerModel" ~~> spinnerData,
            "ItemMainModel" ~~> adDetailsItem,
            ])
    }
}
