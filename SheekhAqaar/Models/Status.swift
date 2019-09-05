//
//  Status.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/5/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class Status: DataType {
    var id : Int!
    var message: String!
    
    //MARK: Decodable
    required public init?(json: JSON){
        id = "Id" <~~ json
        message = "Message" <~~ json
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "Id" ~~> id,
            "Message" ~~> message,
            ])
    }
}
