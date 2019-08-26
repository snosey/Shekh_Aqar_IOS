//
//  User.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/26/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class User: DataType {
    
    var name : String!
    var imageUrl : String!
    var phoneNumber: String!
    var token: String!
    
    //MARK: Decodable
    required public init?(json: JSON){
        token = "token" <~~ json
        name = "name" <~~ json
        phoneNumber = "phone_number" <~~ json
        imageUrl = "imageUrl" <~~ json
    }
    
    public init() {
        
    }
    
    public init(imageUrl : String, name: String, token: String, phoneNumber: String) {
        self.imageUrl = imageUrl
        self.name = name
        self.token = token
        self.phoneNumber = phoneNumber
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "name" ~~> name,
            "token" ~~> token,
            "imageUrl" ~~> imageUrl,
            "phone_number" ~~> phoneNumber,
            ])
    }
    
}
