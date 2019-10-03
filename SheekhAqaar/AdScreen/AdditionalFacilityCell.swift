//
//  AdditionalFacilityCell.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/29/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import Localize_Swift

class AdditionalFacilityCell: UITableViewCell {

    public static let identifier = "AdditionalFacilityCell"
    
    public var additionalFacility1: AdditionalFacility!
    public var additionalFacility2: AdditionalFacility?
    
    @IBOutlet weak var facility1Label: UILabel!
    @IBOutlet weak var facility2Label: UILabel!
    
    public func populateData() {
        if let name1 = additionalFacility1.name {
            facility1Label.text = name1
        } else if let itemFeatureModel = additionalFacility1.itemFeatureModel, let name1 = itemFeatureModel.name {
            facility1Label.text = name1
        }
        
        if let additionalFacility2 = additionalFacility2 {
            if let name2 = additionalFacility2.name {
                facility2Label.text = name2
            } else if let name2 = additionalFacility2.itemFeatureModel.name {
                facility2Label.text = name2
            }
        }
    }
}
