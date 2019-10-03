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
    
    var name : String!
    var id : Int!
    
    //MARK: Decodable
    required public init?(json: JSON){
        name = "Name" <~~ json
        id = "Id" <~~ json
    }
    
    public init() {
        
    }
    
    public init(id : Int, name: String) {
        self.id = id
        self.name = name
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "Name" ~~> name,
            "Id" ~~> id,
            ])
    }
    
}
