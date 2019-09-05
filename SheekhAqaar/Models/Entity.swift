//
//  Entity.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/5/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class Entity<T>: DataType {
    
    public var data: T!
    public var status: Status!
    
    //MARK: Decodable
    required public init?(json: JSON){
        data = "Data" <~~ json
        status = "Status" <~~ json
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "Data" ~~> data,
            "Status" ~~> status,
            ])
    }
}
