//
//  CompanyType.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 10/5/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class CompanyType {
    var companyId : Int!
    var id : Int!
    var serviceId: Int!
    var companyService: Category!
    
    //MARK: Decodable
    required public init?(json: JSON){
        companyId = "Fk_Company" <~~ json
        id = "Id" <~~ json
        serviceId = "Fk_OrgType" <~~ json
        companyService = "OrgTypeModel" <~~ json
    }
    
    public init() {
        
    }
    
    public init(id : Int, nameEn: String, nameAr: String) {
        self.id = id
//        self.name = nameAr
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "Fk_Company" ~~> companyId,
            "Id" ~~> id,
            "Fk_OrgType" ~~> serviceId,
            "OrgTypeModel" ~~> companyService,
            ])
    }
}
