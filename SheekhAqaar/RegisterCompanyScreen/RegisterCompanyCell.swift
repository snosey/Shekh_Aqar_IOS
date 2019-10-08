//
//  RegisterCompanyCell.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/19/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import MapKit
import SwiftyUserDefaults

public protocol RegisterCompanyCellDelegate: class {
    func changeUserAvatar()
    func changeOwnerCountryCode()
    func changeCompanyAvatar()
    func changeCompanyCountryCode()
    func changeCountry()
    func changeRegion()
    func registerClicked()
    func backClicked()
    func serviceChecked(checked: Bool, index: Int)
    func pickPlaceClicked()
}

class RegisterCompanyCell: UITableViewCell {

    public static let identifier = "RegisterCompanyCell"
    
    
    @IBOutlet weak var userDataTitleLabel: LocalizedLabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var changeAvatarImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: LocalizedTextField!
    @IBOutlet weak var phoneNumberTextField: LocalizedTextField!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    
    @IBOutlet weak var companyDataTitleLabel: LocalizedLabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var companyAvatar: UIImageView!
    @IBOutlet weak var changeCompanyAvatar: UIImageView!
    @IBOutlet weak var companyNameTextField: LocalizedTextField!
    @IBOutlet weak var traditionalNumberTextField: LocalizedTextField!
    @IBOutlet weak var companyPhoneNumberTextField: LocalizedTextField!
    @IBOutlet weak var companyCountryCodeView: UIView!
    @IBOutlet weak var companyCountryCodeLabel: UILabel!
    @IBOutlet weak var companyCountryCodeFlag: UIImageView!
    @IBOutlet weak var companyEmail: LocalizedTextField!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var countryNameLabel: LocalizedLabel!
    @IBOutlet weak var regionView: UIView!
    @IBOutlet weak var regionNameLabel: LocalizedLabel!
    @IBOutlet weak var detailedAddressTextField: LocalizedTextField!
    @IBOutlet weak var addressOnMapLabel: LocalizedLabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detectAddressOnGoogleMapsView: UIView!
    @IBOutlet weak var registerButton: LocalizedButton!
    @IBOutlet weak var backLabel: LocalizedLabel!
    @IBOutlet weak var companyServicesTableView: UITableView!
    
    var userImageChoosen: Bool = false
    var companyImageChoosen: Bool = false
    
    public var delegate: RegisterCompanyCellDelegate!
    public var categories: [Category]!
    public var userSelectedCountry: Country!
    public var companySelectedCountry: Country!
    
    public func showCompanyData(company: Company) {
       
        if let url = URL(string: company.imageUrl) {
            companyAvatar.af_setImage(withURL: url)
        }
        
        companyNameTextField.text = company.name
        traditionalNumberTextField.text = String(company.commercialNumber)
        
        for category in categories {
            for companyType in company.companyTypes {
                if companyType.companyService.id == category.id {
                    category.isClicked = true
                }
            }
        }
        companyServicesTableView.reloadData()
        
        companyPhoneNumberTextField.text = company.phoneNumber
        companyCountryCodeLabel.text = "+" + companySelectedCountry.code
       
        if let url = URL(string: companySelectedCountry.imageUrl) {
            companyCountryCodeFlag.af_setImage(withURL: url)
        }
        
        companyEmail.text = company.email
        
        for region in companySelectedCountry.regions {
            if region.id == company.regionId {
                regionNameLabel.text = region.name
                regionNameLabel.textColor = .black
            }
        }
        
        detailedAddressTextField.text = company.address
        
        companyImageChoosen = true
        registerButton.setTitle("editCompany".localized(), for: .normal)
        
    }
    
    public func initializeCell() {
        changeAvatarImageView.addTapGesture { [weak self] (_) in
            self?.delegate.changeUserAvatar()
        }
        
        countryCodeView.addTapGesture { [weak self] (_) in
            self?.delegate.changeOwnerCountryCode()
        }
        
        changeCompanyAvatar.addTapGesture { [weak self] (_) in
            self?.delegate.changeCompanyAvatar()
        }
        
        companyCountryCodeView.addTapGesture { [weak self] (_) in
            self?.delegate.changeCompanyCountryCode()
        }
        
        countryView.addTapGesture { [weak self] (_) in
            self?.delegate.changeCountry()
        }
        
        regionView.addTapGesture { [weak self] (_) in
            self?.delegate.changeRegion()
        }
        
        registerButton.addTapGesture { [weak self] (_) in
            self?.delegate.registerClicked()
        }
        
        mapView.addTapGesture { [weak self] (_) in
            self?.delegate.pickPlaceClicked()
        }
        
        detectAddressOnGoogleMapsView.addTapGesture { [weak self] (_) in
            self?.delegate.pickPlaceClicked()
        }
        
        GradientBG.createGradientLayer(view: registerButton, cornerRaduis: 4, maskToBounds: true)
        
        UiHelpers.makeLabelUnderlined(label: backLabel)
        backLabel.addTapGesture { [weak self] (_) in
            self?.delegate.backClicked()
        }
        
        userAvatarImageView.layer.masksToBounds = true
        
        companyAvatar.layer.masksToBounds = true
        
        companyServicesTableView.backgroundColor = .clear
        companyServicesTableView.dataSource = self
        companyServicesTableView.delegate = self
        companyServicesTableView.reloadData()
        
        if let _ = Defaults[.user] {
            userDataTitleLabel.isHidden = true
            topView.isHidden = true
            
            companyDataTitleLabel.snp.remakeConstraints { (maker) in
                maker.top.equalTo(self.contentView).offset(8)
                maker.leading.equalTo(self.contentView).offset(8)
                maker.trailing.equalTo(self.contentView).offset(-8)
            }
        }
        
        showUserCodeAndFlag()
        showCompanyCodeAndFlag()
    }
    
    func showUserCodeAndFlag() {
        countryCodeLabel.text = "+" + userSelectedCountry.code
        if let url = URL(string: userSelectedCountry.imageUrl) {
            countryFlagImageView.af_setImage(withURL: url)
        }
    }
    
    func showCompanyCodeAndFlag() {
        companyCountryCodeLabel.text = "+" + companySelectedCountry.code
        if let url = URL(string: companySelectedCountry.imageUrl) {
            companyCountryCodeFlag.af_setImage(withURL: url)
        }
    }
}

extension RegisterCompanyCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CompanyServicesCell.identifier, for: indexPath) as! CompanyServicesCell
        
        cell.delegate = self
        cell.category = categories.get(indexPath.row)!
        cell.index = indexPath.row
        cell.populateData()        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 5)
    }
}

extension RegisterCompanyCell: CompanyServicesCellDelegate {
    func serviceChecked(checked: Bool, index: Int) {
        self.categories.get(index)?.isClicked = checked
        companyServicesTableView.reloadData()
        self.delegate.serviceChecked(checked: checked, index: index)
    }
}
