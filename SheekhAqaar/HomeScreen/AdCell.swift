//
//  AdCell.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/26/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import Localize_Swift

class AdCell: UITableViewCell {

    public static let identifier = "AdCell"

    public var ad: Ad!
    
    @IBOutlet weak var adPhotoImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var farshLevelLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var roomsNumberLabel: UILabel!
    @IBOutlet weak var bathroomsNumberLabel: UILabel!
    @IBOutlet weak var creationTimeLabel: UILabel!
    @IBOutlet weak var adTypeLabel: UILabel!
    
    
    public func populateData() {
        if let urls = ad.adImages, urls.count > 0, let photoUrl = URL(string: urls[0].imageUrl) {
            adPhotoImageView.af_setImage(withURL: photoUrl)
        }
        if let price = ad.price, let currency = ad.currency, let currencyName = currency.name {
            priceLabel.text = "\(price.formattedWithSeparator) \(currencyName)"
        }
        
        if let name = ad.name {
            titleLabel.text = name
        }
        
        if let detailedAddress = ad.detailedAddress {
            addressLabel.text = detailedAddress
        }
        
        if let placeArea = ad.placeArea {
            areaLabel.text = String(placeArea)
        }
        
        if let subCategory = ad.subCategory, let name = subCategory.name {
            adTypeLabel.text = name
        }
        
        creationTimeLabel.text = UiHelpers.convertStringToDate(string: ad.creationTime, dateFormat: "dd/MM/yyyy hh:mm a")?.timeAgoDisplay()
    }
}
