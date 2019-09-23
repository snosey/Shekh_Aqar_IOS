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
    var spinnerDataArray: [SpinnerData]!
    
    //MARK: Decodable
    required public init?(json: JSON){
        id = "Id" <~~ json
        name = "Name" <~~ json
        spinnerDataArray = "DataSpinnerModel" <~~ json
    }
    
    public init() {
        
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "Id" ~~> id,
            "Name" ~~> name,
            "DataSpinnerModel" ~~> spinnerDataArray,
            ])
    }
}
