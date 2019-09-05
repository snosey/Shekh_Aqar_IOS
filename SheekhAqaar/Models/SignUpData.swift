//
//  SignUpData.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/5/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class SignUpData: DataType {
    var categories : [Category]!
    var countries: [Country]!
    
    //MARK: Decodable
    required public init?(json: JSON){
        categories = "OrgTypesModel" <~~ json
        countries = "CountriesModel" <~~ json
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "OrgTypesModel" ~~> categories,
            "CountriesModel" ~~> countries,
            ])
    }
    
    public init() {
        
    }
}
