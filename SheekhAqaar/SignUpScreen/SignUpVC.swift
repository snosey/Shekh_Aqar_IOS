//
//  SignUpVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/18/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import MICountryPicker
import FirebaseAuth
import SwiftyUserDefaults

class SignUpVC: BaseVC {
    
    @IBOutlet weak var phoneNumberTextField: LocalizedTextField!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var loginButton: LocalizedButton!
    @IBOutlet weak var registerAsCompany: LocalizedLabel!
    @IBOutlet weak var skipLabel: LocalizedLabel!
    
    var code: String = "966"
    
    public class func buildVC() -> SignUpVC {
        let storyboard = UIStoryboard(name: "SignUpStoryboard", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryCodeView.addTapGesture { [weak self] (_) in
            self?.showCountriesList()
        }
        
        skipLabel.addTapGesture { [weak self] (_) in
            // go to home screen
            self?.navigator.navigateToHome()
        }
        
//        loginButton.backgroundColor = UIColor.AppColors.start
        
        registerAsCompany.addTapGesture { [weak self] (_) in
            // go to register company screen
            self?.navigator.navigateToRegisterAsCompany()
        }
        
        UiHelpers.makeLabelUnderlined(label: skipLabel)
        UiHelpers.makeLabelUnderlined(label: registerAsCompany)
        
        GradientBG.createGradientLayer(view: loginButton, cornerRaduis: 8, maskToBounds: true)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func showCountriesList() {
        
        let picker = MICountryPicker()
        navigationController?.pushViewController(picker, animated: true)
        
        picker.didSelectCountryWithCallingCodeClosure = { name, code, dialCode in
            let bundle = "assets.bundle/"
            self.countryFlagImageView.image = UIImage(named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
            self.countryCodeLabel.text = dialCode
            self.code = dialCode
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        if let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty {
            if phoneNumber.isNumber() {
                print(phoneNumber)
                var userPhone = phoneNumber
                if userPhone.first == "0" {
                    userPhone.removeFirst()
                }
                userPhone = "\(code)\(userPhone)"
                print(userPhone)
                PhoneAuthProvider.provider().verifyPhoneNumber(userPhone, uiDelegate: nil) { [weak self] (verificationID, error) in
                    if let error = error {
                        print("error :: \(error.localizedDescription)")
                        return
                    }

                    Defaults[.authVerificationID] = verificationID

                    /*
                     Should check account exist here and send to verification screen the next screen
                     if exist --> home
                     if not exist --> sign up
                     */
                    self?.navigator.navigateToPhoneVerification(phoneNumber: userPhone, nextPage: CommonConstants.HOME_NEXT_PAGE_CODE)
                }
            } else {
                self.view.makeToast("enterValidPhoneNumber".localized())
            }
        } else {
            self.view.makeToast("enterPhoneField".localized())
        }
    }
}
