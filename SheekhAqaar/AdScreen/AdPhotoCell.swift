//
//  AdPhotoCell.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/29/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

class AdPhotoCell: UICollectionViewCell {
    public static let identifier = "AdPhotoCell"
    
    @IBOutlet weak var adPhotoImageView: UIImageView!
    
    public var imageUrl: String!
    
    public func populateData() {
        if let url = URL(string: imageUrl) {
            adPhotoImageView.af_setImage(withURL: url)
        }
    }
}
