//
//  HelpModel.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/23/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class HelpData: DataType {
    var id : Int!
    var phone: String!
    var about: String!
    var mobile: String!
    var whatsApp: String!
    var email: String!
    var facebook: String!
    var twitter: String!
    var instagram: String!
    var address: String!
    
    //MARK: Decodable
    required public init?(json: JSON){
        id = "Id" <~~ json
        phone = "Phone" <~~ json
        about = "About" <~~ json
        mobile = "Mobile" <~~ json
        whatsApp = "WhatsApp" <~~ json
        email = "Email" <~~ json
        facebook = "Facebook" <~~ json
        twitter = "Twitter" <~~ json
        instagram = "Instagram" <~~ json
        address = "Address" <~~ json
    }
    
    public init() {
        
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "Id" ~~> id,
            "Phone" ~~> phone,
            "About" ~~> about,
            "Mobile" ~~> mobile,
            "WhatsApp" ~~> whatsApp,
            "Email" ~~> email,
            "Facebook" ~~> facebook,
            "Twitter" ~~> twitter,
            "Instagram" ~~> instagram,
            "Address" ~~> address,
            ])
    }
}
