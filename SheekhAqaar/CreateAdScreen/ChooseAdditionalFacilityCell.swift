//
//  AdditionalFacilityCell.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/2/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import Localize_Swift

public protocol ChooseAdditionalFacilityCellDelegate: class {
    func facilityChecked(checked: Bool, index: Int)
}

class ChooseAdditionalFacilityCell: UITableViewCell {

    public static let identifier = "ChooseAdditionalFacilityCell"
    
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var facilityNameLabel: UILabel!
    
    public var index: Int!
    public var additionalFacility: AdditionalFacility!
    public var delegate: ChooseAdditionalFacilityCellDelegate!
    
    public func populateData() {
        contentView.backgroundColor = .clear
        if additionalFacility.isChecked {
            checkImageView.image = UIImage(named: "checked")
        } else {
            checkImageView.image = UIImage(named: "unchecked")
        }
        
        checkImageView.addTapGesture { [weak self] (_) in
            self?.delegate.facilityChecked(checked: !(self?.additionalFacility.isChecked ?? false), index: self?.index ?? 0)
        }
        
        facilityNameLabel.addTapGesture { [weak self] (_) in
            self?.delegate.facilityChecked(checked: !(self?.additionalFacility.isChecked ?? false), index: self?.index ?? 0)
        }
        if Localize.currentLanguage() == "ar" {
            facilityNameLabel.text = self.additionalFacility.nameAr
        } else {
            facilityNameLabel.text = self.additionalFacility.nameEn
        }
    }

}
