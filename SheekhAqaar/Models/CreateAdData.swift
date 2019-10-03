//
//  CreateAdData.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/23/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class CreateAdData: DataType {
    var additionalFacilities: [AdditionalFacility]!
    var adDetailsItems: [AdDetailsItem]!
    var currencies: [Currency]!
    
    //MARK: Decodable
    required public init?(json: JSON){
        additionalFacilities = "ItemFeatureModel" <~~ json
        adDetailsItems = "ItemMainModel" <~~ json
        currencies = "CurrencyModel" <~~ json
    }
    
    public init() {
        
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "ItemFeatureModel" ~~> additionalFacilities,
            "ItemMainModel" ~~> adDetailsItems,
            "CurrencyModel" ~~> currencies,
            ])
    }
}
