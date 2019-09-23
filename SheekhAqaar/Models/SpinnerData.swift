//
//  SpinnerData.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/23/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class SpinnerData: DataType {
    var name: String!
    
    //MARK: Decodable
    required public init?(json: JSON){
        name = "Name" <~~ json
    }
    
    public init() {
        
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "Name" ~~> name,
            ])
    }
}
