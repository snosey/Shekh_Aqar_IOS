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
    
    var id: Int!
    var name : String!
    var imageUrl : String!
    var phoneNumber: String!
    var token: String!
    var language: Int!
    var countryId: Int!
    var regionId: Int!
    var userType: Int!
    
    //MARK: Decodable
    required public init?(json: JSON){
        id = "Id" <~~ json
        token = "Token" <~~ json
        name = "Name" <~~ json
        phoneNumber = "Phone" <~~ json
        imageUrl = "ImageUrl" <~~ json
        language = "Fk_Language" <~~ json
        countryId = "Fk_Country" <~~ json
        regionId = "Fk_UserState" <~~ json
        userType = "Fk_UserType" <~~ json
    }
    
    public init() {
        
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "Id" ~~> id,
            "Name" ~~> name,
            "Token" ~~> token,
            "ImageUrl" ~~> imageUrl,
            "Phone" ~~> phoneNumber,
            "Fk_Language" ~~> language,
            "Fk_Country" ~~> countryId,
            "Fk_UserState" ~~> regionId,
            "Fk_UserType" ~~> userType,
            ])
    }
    
}

public enum UserType: Int {    
    case USER = 1
    case ADMIN = 2
    case COMPANY = 4
}
