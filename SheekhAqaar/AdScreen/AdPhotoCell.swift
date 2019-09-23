//
//  AdPhotoCell.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/29/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

protocol AdPhotoCellDelegate {
    func removeImage(index: Int)
}

class AdPhotoCell: UICollectionViewCell {
    public static let identifier = "AdPhotoCell"
    
    @IBOutlet weak var adPhotoImageView: UIImageView!
    
    @IBOutlet weak var removeIconImageView: UIImageView!
    public var imageUrl: String!
    public var index: Int!
    public var delegate: AdPhotoCellDelegate!
    public func populateData() {
        if let url = URL(string: imageUrl) {
            adPhotoImageView.af_setImage(withURL: url)
            
        }
    }
    
    public func configureRemoveIcon() {
        if let _ = removeIconImageView {
            removeIconImageView.addTapGesture { [weak self](_) in
                self?.delegate.removeImage(index: self?.index ?? 0)
            }
        }
    }
}
