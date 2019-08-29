//
//  AdDetailsCell.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/29/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

class AdDetailsCell: UITableViewCell {

    public static let identifier = "AdDetailsCell"
    
    public var adDetail: AdDetail!

    @IBOutlet weak var adDetailImageView: UIImageView!
    @IBOutlet weak var adDetailTitleLabel: UILabel!
    @IBOutlet weak var adDetailDescLabel: UILabel!
    
    public func populateData() {
        adDetailTitleLabel.text = adDetail.title
        adDetailDescLabel.text = adDetail.details
        adDetailImageView.image = UIImage(named: adDetail.imageName)
    }
}
