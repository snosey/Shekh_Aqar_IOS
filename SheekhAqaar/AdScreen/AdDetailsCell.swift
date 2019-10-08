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
    
//    public var adDetail: AdDetail!
    public var itemMainModel: ItemMainModel!
    
    @IBOutlet weak var adDetailImageView: UIImageView!
    @IBOutlet weak var adDetailTitleLabel: UILabel!
    @IBOutlet weak var adDetailDescLabel: UILabel!
    
    public func populateData() {
        adDetailTitleLabel.text = itemMainModel.adDetailsItem.name
        if let value = itemMainModel.value {
            adDetailDescLabel.text = "\(value)"
        }
        
        if let imageUrl = itemMainModel.adDetailsItem.imageUrl, let url = URL(string: imageUrl) {
            adDetailImageView.af_setImage(withURL: url, placeholderImage: UIImage(named: "splash_icon"))
            if adDetailImageView.image == UIImage(named: "splash_icon") {
                adDetailImageView.contentMode = .scaleToFill
            }
        }
    }
    
    public func populateFirst3Rows(title: String, value: String, image: UIImage) {
        adDetailTitleLabel.text = title
        adDetailDescLabel.text = value
        adDetailImageView.image = image
    }
}
