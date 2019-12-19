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
        priceLabel.text = "\(ad.price!) \(ad.currency.name!)"
        titleLabel.text = ad.name
        addressLabel.text = ad.detailedAddress
        areaLabel.text = "\(ad.placeArea ?? 0)"
        adTypeLabel.text = ad.subCategory.name
        creationTimeLabel.text = UiHelpers.convertStringToDate(string: ad.creationTime, dateFormat: "dd/MM/yyyy hh:mm a").timeAgoDisplay()
    }
}
