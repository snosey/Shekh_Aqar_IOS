//
//  AddressCell.swift
//  Sheekhaqaar
//
//  Created by Hesham Donia on 5/12/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

public protocol AddressCellDelegate: class {
    func itemClicked( index: Int)
}

class AddressCell: UITableViewCell {

    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var addressCityNameLabel: UILabel!
    
    var address: Address!
    var index: Int!
    var delegate: AddressCellDelegate!
    
    public func populateData() {
        addressNameLabel.text = address.addressName
        addressCityNameLabel.text = address.addressCityName
        
        self.contentView.addTapGesture { [weak self] (_) in
            self?.delegate.itemClicked(index: self?.index ?? 0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
