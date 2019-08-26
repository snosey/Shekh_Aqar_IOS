//
//  RegisterCompanyCell.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/19/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import MapKit

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
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var changeAvatarImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: LocalizedTextField!
    @IBOutlet weak var phoneNumberTextField: LocalizedTextField!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    
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
    @IBOutlet weak var registerButton: LocalizedButton!
    @IBOutlet weak var backLabel: LocalizedLabel!
    @IBOutlet weak var companyServicesTableView: UITableView!
    
    var userImageChoosen: Bool = false
    var companyImageChoosen: Bool = false
    
    public var delegate: RegisterCompanyCellDelegate!
    public var services: [CompanyService]!
    
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
        
        GradientBG.createGradientLayer(view: registerButton, cornerRaduis: 8, maskToBounds: true)
        
        UiHelpers.makeLabelUnderlined(label: backLabel)
        backLabel.addTapGesture { [weak self] (_) in
            self?.delegate.backClicked()
        }
        
        userAvatarImageView.layer.masksToBounds = true
        userAvatarImageView.layer.cornerRadius = UiHelpers.getLengthAccordingTo(relation: .VIEW_HEIGHT, relativeView: topView, percentage: 45) / 2
        
        companyAvatar.layer.masksToBounds = true
        companyAvatar.layer.cornerRadius = UiHelpers.getLengthAccordingTo(relation: .VIEW_HEIGHT, relativeView: bottomView, percentage: 15) / 2
        
        companyServicesTableView.backgroundColor = .clear
        companyServicesTableView.dataSource = self
        companyServicesTableView.delegate = self
        companyServicesTableView.reloadData()
    }
}

extension RegisterCompanyCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CompanyServicesCell.identifier, for: indexPath) as! CompanyServicesCell
        
        cell.delegate = self
        cell.service = services.get(indexPath.row)!
        cell.index = indexPath.row
        cell.populateData()        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 5)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "companyServices".localized()
        label.textAlignment = .natural
        label.textColor = .white
        return label
    }
}

extension RegisterCompanyCell: CompanyServicesCellDelegate {
    func serviceChecked(checked: Bool, index: Int) {
        self.services.get(index)?.isChecked = checked
        companyServicesTableView.reloadData()
        self.delegate.serviceChecked(checked: checked, index: index)
    }
}
