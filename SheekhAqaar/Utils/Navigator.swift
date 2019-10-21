//
//  Navigator.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/17/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import UIKit

public class Navigator {
    
    var navigationController: UINavigationController!
    
    public init(navController: UINavigationController) {
        self.navigationController = navController
    }
    
    public func navigateToSignUp() {
        weak var vc = SignUpVC.buildVC()
        if let vc = vc {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    public func navigateToSignUp1(phoneNumber: String, country: Country) {
        weak var vc = SignUp1VC.buildVC(phoneNumber: phoneNumber, country: country)
        if let vc = vc {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    public func navigateToPhoneVerification(phoneNumber: String, nextPage: Int, country: Country, userImage: UIImage? = nil, username: String? = nil) {
        weak var vc = PhoneVerificationVC.buildVC(phoneNumber: phoneNumber, nextPage: nextPage, country: country, userImage: userImage, userName: username)
        if let vc = vc {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    public func navigateToRegisterAsCompany() {
        weak var vc = RegisterCompanyVC.buildVC()
        if let vc = vc {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    public func navigateToHome() {
        weak var vc = HomeVC.buildVC()
        if let vc = vc {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    public func navigateToCompany(company: Company) {
        weak var vc = CompanyVC.buildVC(company: company)
        if let vc = vc {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    public func navigateToHelp() {
        weak var vc = HelpVC.buildVC()
        if let vc = vc {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    public func navigateToAdDetails(ad: Ad) {
        weak var vc = AdVC.buildVC(ad: ad)
        if let vc = vc {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    public func navigateToFavourites() {
        weak var vc = FavouritesVC.buildVC()
        if let vc = vc {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    public func navigateToCreateAd() {
        weak var vc = CreateAdVC.buildVC()
        if let vc = vc {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    public func navigateToEditAd(ad: Ad) {
        weak var vc = EditAdVC.buildVC(ad: ad)
        if let vc = vc {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    public func navigateToRequestBuilding() {
        weak var vc = RequestBuildingVC.buildVC()
        if let vc = vc {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    public func navigateToMyAds() {
        weak var vc = MyAdsVC.buildVC()
        if let vc = vc {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    public func navigateToEditProfile() {
        weak var vc = EditProfileVC.buildVC()
        if let vc = vc {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    public func navigateToEditCompany() {
        weak var vc = EditCompanyVC.buildVC()
        if let vc = vc {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    public func navigateToAddressPicker(delegate: LocationSelectionDelegate) {
        weak var vc = AddressPickerVC.buildVC(delegate: delegate)
        if let vc = vc {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    public func navigateToAddressPickerWithMap(delegate: LocationSelectionDelegate) {
        weak var vc = AddressPickerWithMapVC.buildVC(delegate: delegate)
        if let vc = vc {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
}
