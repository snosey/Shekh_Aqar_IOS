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
    
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    var adDetailsItem: AdDetailsItem!
    
    public func populateData() {
        if let imageUrl = adDetailsItem.imageUrl, let url = URL(string: imageUrl) {
            detailsImageView.af_setImage(withURL: url)
        }
        titleLabel.text = adDetailsItem.name
        if let value = adDetailsItem.value {
            valueTextField.text = "\(value)"
        } else {
            valueTextField.placeholder = "pleaseInsert".localized() + adDetailsItem.name
        }
    }
}
