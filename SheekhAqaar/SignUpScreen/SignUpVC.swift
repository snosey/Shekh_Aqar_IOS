//
//  SignUpVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/18/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
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
    var code = ""
    var userPhone = ""
    var selectedCountry: Country!
    
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
            Defaults[.isSkipped] = true
            self?.navigator.navigateToHome()
        }
                
        registerAsCompany.addTapGesture { [weak self] (_) in
            // go to register company screen
            self?.navigator.navigateToRegisterAsCompany()
        }
        
        UiHelpers.makeLabelUnderlined(label: skipLabel)
        UiHelpers.makeLabelUnderlined(label: registerAsCompany)
        
        GradientBG.createGradientLayer(view: loginButton, cornerRaduis: 4, maskToBounds: true)
        
        presenter = Injector.provideSignUpPresenter()
        presenter.setView(view: self)
        presenter.getSignUpData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func showCountriesList() {
        let vc = CountriesListVC.buildVC(countries: Singleton.getInstance().signUpData.countries)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        
        if selectedCountry != nil {
            if let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty {
                if phoneNumber.isNumber() {
                    print(phoneNumber)
                    userPhone = phoneNumber
                    presenter.login(phoneNumber: userPhone, countryId: self.selectedCountry.id)
                } else {
                    self.view.makeToast("enterValidPhoneNumber".localized())
                }
            } else {
                self.view.makeToast("enterPhoneField".localized())
            }
        } else {
            self.view.makeToast("selectCountryError".localized())
        }
    }
}

extension SignUpVC: SignUpView {
    
    func getSignUpDataSuccess() {
        if let country = Singleton.getInstance().signUpData.countries.get(0) {
            if let url = URL(string: country.imageUrl) {
                self.countryFlagImageView.af_setImage(withURL: url)
            }
            self.countryCodeLabel.text = "+" + country.code
            self.code = "+" + country.code
            self.selectedCountry = country
        }
    }
    
    func loginSuccess(user: User?, isExist: Bool) {
        let phone = "\(code)\(userPhone)"
        if isExist {
            Defaults[.user] = user!.toJSON()
            if let companies = user?.companies, companies.count > 0 {
                let company = companies[0]
                Defaults[.company] = company.toJSON()
            }
            navigator.navigateToHome()
//            PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { [weak self] (verificationID, error) in
//                if let error = error {
//                    print("error :: \(error.localizedDescription)")
//                    return
//                }
//
//                Defaults[.authVerificationID] = verificationID
//
//                self?.navigator.navigateToPhoneVerification(phoneNumber: self?.userPhone ?? "", nextPage: CommonConstants.HOME_NEXT_PAGE_CODE, country: self!.selectedCountry)
//            }
        } else {
            navigator.navigateToSignUp1(phoneNumber: userPhone, country: selectedCountry)
//            PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { [weak self] (verificationID, error) in
//                if let error = error {
//                    print("error :: \(error.localizedDescription)")
//                    return
//                }
//
//                Defaults[.authVerificationID] = verificationID
//
//                self?.navigator.navigateToPhoneVerification(phoneNumber: self?.userPhone ?? "", nextPage: CommonConstants.SIGN_UP_NEXT_PAGE_CODE, country: self!.selectedCountry)
//            }
        }
    }
    
    func failed(errorMessage: String) {
        self.view.makeToast(errorMessage)
    }
    
    func handleNoInternetConnection() {
        self.view.makeToast("noInternetConnection".localized())
    }
}

extension SignUpVC: CountriesListDelegate {
    func countrySelected(country: Country?) {
        if let country = country {
            if let url = URL(string: country.imageUrl) {
                self.countryFlagImageView.af_setImage(withURL: url)
            }
            self.countryCodeLabel.text = "+" + country.code
            self.code = "+" + country.code
            self.selectedCountry = country
        }
    }
}
