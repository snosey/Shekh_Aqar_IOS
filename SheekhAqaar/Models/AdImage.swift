//
//  AdImage.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/10/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss
/*
 public int Id;
 public String ImageURL;
 */

public class AdImage: DataType {
    var id : Int!
    var imageUrl: String!
    var adId: Int!
    
    //MARK: Decodable
    required public init?(json: JSON){
        id = "Id" <~~ json
        imageUrl = "ImageURL" <~~ json
        adId = "Fk_UserItem" <~~ json
    }
    
    public init() {
        
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "Id" ~~> id,
            "ImageURL" ~~> imageUrl,
            "Fk_UserItem" ~~> adId,
            ])
    }
}
