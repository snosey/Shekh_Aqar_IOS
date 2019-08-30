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
    
    public func navigateToSignUp1(phoneNumber: String) {
        weak var vc = SignUp1VC.buildVC(phoneNumber: phoneNumber)
        if let vc = vc {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    public func navigateToPhoneVerification(phoneNumber: String, nextPage: Int) {
        weak var vc = PhoneVerificationVC.buildVC(phoneNumber: phoneNumber, nextPage: nextPage)
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
}
