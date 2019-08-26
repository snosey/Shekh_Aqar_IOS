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
    
    
    var presenter: SignUpPresenter!
    var code: String = "966"
    var userPhone = ""
    
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
                
        registerAsCompany.addTapGesture { [weak self] (_) in
            // go to register company screen
            self?.navigator.navigateToRegisterAsCompany()
        }
        
        UiHelpers.makeLabelUnderlined(label: skipLabel)
        UiHelpers.makeLabelUnderlined(label: registerAsCompany)
        
        GradientBG.createGradientLayer(view: loginButton, cornerRaduis: 8, maskToBounds: true)
        
        presenter = Injector.provideSignUpPresenter()
        presenter.setView(view: self)
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
                userPhone = phoneNumber
                if userPhone.first == "0" {
                    userPhone.removeFirst()
                }
                userPhone = "\(code)\(userPhone)"
                print(userPhone)
                presenter.checkUserExist(phoneNumber: userPhone)
                
            } else {
                self.view.makeToast("enterValidPhoneNumber".localized())
            }
        } else {
            self.view.makeToast("enterPhoneField".localized())
        }
    }
}

extension SignUpVC: SignUpView {
    func failed(errorMessage: String) {
        self.view.makeToast(errorMessage)
    }
    
    func userCheck(isExist: Bool) {
        if isExist {
            self.navigator.navigateToHome()
        } else {
            PhoneAuthProvider.provider().verifyPhoneNumber(userPhone, uiDelegate: nil) { [weak self] (verificationID, error) in
                if let error = error {
                    print("error :: \(error.localizedDescription)")
                    return
                }
                
                Defaults[.authVerificationID] = verificationID
                
                self?.navigator.navigateToPhoneVerification(phoneNumber: self?.userPhone ?? "", nextPage: CommonConstants.SIGN_UP_NEXT_PAGE_CODE)
            }
        }
    }
    
    func handleNoInternetConnection() {
        self.view.makeToast("noInternetConnection".localized())
    }
}
