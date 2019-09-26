//
//  AdDetailsWithoutSpinnerCell.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/23/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

class AdDetailsWithoutSpinnerCell: UITableViewCell {

    public static let identifier = "AdDetailsWithoutSpinnerCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    var adDetailsItem: AdDetailsItem!
    
    public func populateData() {
        titleLabel.text = adDetailsItem.name
        valueTextField.placeholder = "pleaseInsert".localized() + adDetailsItem.name
    }
}
