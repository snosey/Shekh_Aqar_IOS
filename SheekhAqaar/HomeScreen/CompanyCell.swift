//
//  CompanyCell.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/24/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import Localize_Swift

protocol CompanyCellDelegate: class {
    func callCompanyClicked(phoneNumber: String)
    func openMapsClicked(latitude: Double, longitude: Double)
    func goToCompanyScreen(company: Company?)
}

class CompanyCell: UITableViewCell {

    public static let identifier = "CompanyCell"
    
    public var company: Company!
    public var delegate: CompanyCellDelegate!
    
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyAddressLabel: UILabel!
    @IBOutlet weak var companyNumberOfAdsLabel: UILabel!
    @IBOutlet weak var callImageView: UIImageView!
    @IBOutlet weak var mapImageView: UIImageView!
    
    public func initializeCell() {
        callImageView.addTapGesture { [weak self] (_) in
            self?.delegate.callCompanyClicked(phoneNumber: self?.company.phoneNumber ?? "")
        }
        
        mapImageView.addTapGesture { [weak self] (_) in
            self?.delegate.openMapsClicked(latitude: Double(self?.company.latitude ?? "") ?? 0, longitude: Double(self?.company.longitude ?? "") ?? 0)
        }
        
        contentView.addTapGesture { [weak self] (_) in
            self?.delegate.goToCompanyScreen(company: self?.company)
        }
    }

    public func populateData() {
        if let url = URL(string: company.imageUrl) {
            companyImageView.af_setImage(withURL: url)
        }
        companyNameLabel.text = company.name
        companyAddressLabel.text = company.address
        
        companyNumberOfAdsLabel.text = "\("adsNumber".localized()) \(company.numberOfAds!)"
    }
}
