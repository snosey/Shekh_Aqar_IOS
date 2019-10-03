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
        facility1Label.text = additionalFacility1.name
        if let additionalFacility2 = additionalFacility2 {
            facility2Label.text = additionalFacility2.name
        }
    }
}
