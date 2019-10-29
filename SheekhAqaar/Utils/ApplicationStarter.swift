//
//  ApplicationStarter.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/18/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Localize_Swift
import SwiftyUserDefaults
import UIKit
import Material
import Firebase
import GoogleMaps
import GooglePlaces

public class ApplicationStarter {
    
    
    var window: UIWindow?
    
    func startApplication(window: UIWindow?) {
        
        FirebaseApp.configure()
        
        Localize.setCurrentLanguage("ar")
        
        self.window = window
        
        
        GMSServices.provideAPIKey(CommonConstants.GOOGLE_MAPS_KEY)
        GMSPlacesClient.provideAPIKey(CommonConstants.GOOGLE_MAPS_KEY)
        
        switch Localize.currentLanguage() {
        case "ar":
            setSemanticContentAttributeAndContentHorizontalAlignment(semanticContentAttribute: .forceRightToLeft, contentHorizontalAlignment: .right)
            break
            
        case "en":
            setSemanticContentAttributeAndContentHorizontalAlignment(semanticContentAttribute: .forceLeftToRight, contentHorizontalAlignment: .left)
            break
            
        default:
            break
        }
        
        // setting the font and text color for tab bar items
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.AppColors.darkGray, NSAttributedString.Key.font: AppFont.font(type: .Bold, size: 12)], for: .normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "#1E1C21")!, NSAttributedString.Key.font: AppFont.font(type: .Bold, size: 12)], for: .selected)
        
        checkUserExistAndDecideTheWay()
        
    }
    
    private func checkUserExistAndDecideTheWay() {
        let repo = Injector.provideSignUpRepository()
        var vc: UIViewController!
        vc = SignUpVC.buildVC()
        if let _ = Defaults[.user] {
            let user = User(json: Defaults[.user]!)!
            repo.setDelegate(delegate: self)
            repo.login(token: user.token)
        } else {
            if let isSkipped = Defaults[.isSkipped], isSkipped {
                vc = HomeVC.buildVC()
            } else {
                vc = SignUpVC.buildVC()
            }
            
            navigateToSpecificScreen(vc: vc)
        }
    }

    private func navigateToSpecificScreen(vc: UIViewController) {
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func setSemanticContentAttributeAndContentHorizontalAlignment(semanticContentAttribute: UISemanticContentAttribute,contentHorizontalAlignment: UIControl.ContentHorizontalAlignment) {
        Switch.appearance().semanticContentAttribute = semanticContentAttribute
        UIView.appearance().semanticContentAttribute = semanticContentAttribute
        UILabel.appearance().semanticContentAttribute = semanticContentAttribute
        FlatButton.appearance().semanticContentAttribute = semanticContentAttribute
        FlatButton.appearance().contentHorizontalAlignment = contentHorizontalAlignment
        RaisedButton.appearance().contentHorizontalAlignment = contentHorizontalAlignment
        RaisedButton.appearance().semanticContentAttribute = semanticContentAttribute
        Button.appearance().contentHorizontalAlignment = contentHorizontalAlignment
        Button.appearance().semanticContentAttribute = semanticContentAttribute
        UIButton.appearance().semanticContentAttribute = semanticContentAttribute
        UIImageView.appearance().semanticContentAttribute = semanticContentAttribute
        UITableView.appearance().semanticContentAttribute = semanticContentAttribute
        UICollectionView.appearance().semanticContentAttribute = semanticContentAttribute
        UINavigationBar.appearance().semanticContentAttribute = semanticContentAttribute
        UITabBar.appearance().semanticContentAttribute = semanticContentAttribute
        ErrorTextField.appearance().semanticContentAttribute = semanticContentAttribute
        TextField.appearance().semanticContentAttribute = semanticContentAttribute
        UITableViewCell.appearance().semanticContentAttribute = semanticContentAttribute
        UICollectionViewCell.appearance().semanticContentAttribute = semanticContentAttribute
        UISearchBar.appearance().semanticContentAttribute = semanticContentAttribute
        UIProgressView.appearance().semanticContentAttribute = semanticContentAttribute
        UITextField.appearance().semanticContentAttribute = semanticContentAttribute
    }
}

extension ApplicationStarter: SignUpPresenterDelegate {
    public func loginSuccess(user: User?, isExist: Bool) {
        
        var vc: UIViewController!
        
        if isExist {
            vc = HomeVC.buildVC()
        } else {
            vc = SignUpVC.buildVC()
        }
        
        navigateToSpecificScreen(vc: vc)
    }
    
    public func getSignUpDataSuccess(signUpData: SignUpData) {
        
    }
    
    public func failed(errorMessage: String) {
        print(errorMessage)
    }
}
