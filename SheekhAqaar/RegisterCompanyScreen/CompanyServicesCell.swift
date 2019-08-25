//
//  CompanyServicesCell.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/25/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import Localize_Swift

public protocol CompanyServicesCellDelegate: class {
    func serviceChecked(checked: Bool, index: Int)
}

class CompanyServicesCell: UITableViewCell {
 
    public static let identifier = "CompanyServicesCell"
    
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    
    public var index: Int!
    public var service: CompanyService!
    public var delegate: CompanyServicesCellDelegate!
    
    public func populateData() {
        contentView.backgroundColor = .clear
        if service.isChecked {
           checkImageView.image = UIImage(named: "checked")
        } else {
            checkImageView.image = UIImage(named: "unchecked")
        }
        
        checkImageView.addTapGesture { [weak self] (_) in
            self?.delegate.serviceChecked(checked: !(self?.service.isChecked ?? false), index: self?.index ?? 0)
        }
        
        serviceNameLabel.addTapGesture { [weak self] (_) in
            self?.delegate.serviceChecked(checked: !(self?.service.isChecked ?? false), index: self?.index ?? 0)
        }
        if Localize.currentLanguage() == "ar" {
            serviceNameLabel.text = self.service.nameAr
        } else {
            serviceNameLabel.text = self.service.nameEn
        }
    }
}
