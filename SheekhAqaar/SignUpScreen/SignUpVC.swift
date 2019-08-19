//
//  SignUpVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/18/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
//import CountryPickerView
import MICountryPicker

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
            self?.showCountryList()
        }
        
        skipLabel.addTapGesture { [weak self] (_) in
            // go to home screen
        }
        
        loginButton.backgroundColor = UIColor.AppColors.start
        
        registerAsCompany.addTapGesture { [weak self] (_) in
            // go to register company screen
        }
        
        UiHelpers.makeLabelUnderlined(label: skipLabel)
        UiHelpers.makeLabelUnderlined(label: registerAsCompany)
        
//        let gradientBG = GradientBG()
//        gradientBG.view = loginButton
//        gradientBG.createGradientLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func showCountryList() {
        
        let picker = MICountryPicker()
        navigationController?.pushViewController(picker, animated: true)
        
        picker.didSelectCountryWithCallingCodeClosure = { name, code, dialCode in
            let bundle = "assets.bundle/"
            self.countryFlagImageView.image = UIImage(named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
            self.countryCodeLabel.text = dialCode
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        if let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty {
            if phoneNumber.isNumber() {
                navigator.navigateToSignUp1(phoneNumber: phoneNumber)
            } else {
                self.view.makeToast("enterValidPhoneNumber".localized())
            }
        } else {
            self.view.makeToast("enterPhoneField".localized())
        }
    }
}
