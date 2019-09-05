//
//  CountriesListCell.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/5/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

class CountriesListCell: UITableViewCell {

     public static let identifier = "CountriesListCell"

    @IBOutlet weak var countryPhotoImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    public var country: Country!
    
    public func populateData() {
        countryNameLabel.text = country.name
        countryCodeLabel.text = country.code
        if let url = URL(string: country.imageUrl) {
            countryPhotoImageView.af_setImage(withURL: url)
        }
    }
    
}
