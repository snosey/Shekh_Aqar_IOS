//
//  PhoneVerificationVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/18/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftyUserDefaults

class PhoneVerificationVC: BaseVC {

    public class func buildVC(phoneNumber: String, nextPage: Int, country: Country) -> PhoneVerificationVC {
        let storyboard = UIStoryboard(name: "PhoneVerificationStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PhoneVerificationVC") as! PhoneVerificationVC
        vc.phoneNumber = phoneNumber
        vc.nextPage = nextPage
        vc.country = country
        return vc
    }
    
    @IBOutlet weak var digit1: UITextField!
    @IBOutlet weak var digit2: UITextField!
    @IBOutlet weak var digit3: UITextField!
    @IBOutlet weak var digit4: UITextField!
    @IBOutlet weak var digit5: UITextField!
    @IBOutlet weak var digit6: UITextField!
    
    @IBOutlet weak var resendCodeLabel: LocalizedLabel!
    @IBOutlet weak var backLabel: LocalizedLabel!
    @IBOutlet weak var confirmButton: LocalizedButton!
    
    
    var phoneNumber: String!
    var nextPage: Int!
    var country: Country!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UiHelpers.makeLabelUnderlined(label: resendCodeLabel)
        UiHelpers.makeLabelUnderlined(label: backLabel)
        
        resendCodeLabel.addTapGesture { [weak self](_) in
            self?.digit1.text = ""
            self?.digit2.text = ""
            self?.digit3.text = ""
            self?.digit4.text = ""
            self?.digit5.text = ""
            self?.digit6.text = ""
            
            PhoneAuthProvider.provider().verifyPhoneNumber(self?.phoneNumber ?? "", uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    print("error :: \(error.localizedDescription)")
                    return
                }
                
                Defaults[.authVerificationID] = verificationID
            }
        }
        
        backLabel.addTapGesture { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        digit1.delegate = self
        digit2.delegate = self
        digit3.delegate = self
        digit4.delegate = self
        digit5.delegate = self
        digit6.delegate = self
        
        digit1.becomeFirstResponder()
        
        GradientBG.createGradientLayer(view: confirmButton, cornerRaduis: 4, maskToBounds: true)
    }

    @IBAction func confirmClicked(_ sender: Any) {
        
        if let verificationID = Defaults[.authVerificationID] {
            if digit1.text?.isEmpty ?? true || digit2.text?.isEmpty ?? true || digit3.text?.isEmpty ?? true || digit4.text?.isEmpty ?? true || digit5.text?.isEmpty ?? true || digit6.text?.isEmpty ?? true {
                self.view.makeToast("emptyFieldsError".localized())
            } else {
                let verificationCodeFirst4 = digit1.text! + digit2.text! + digit3.text! + digit4.text!
                let verificationCode = verificationCodeFirst4 + digit5.text! + digit6.text!
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: verificationID,
                    verificationCode: verificationCode)
                
                Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
                    if let error = error {
                        print("error :: \(error.localizedDescription)")
                        return
                    }
                    
                    if self?.nextPage == CommonConstants.HOME_NEXT_PAGE_CODE {
                        self?.navigator.navigateToHome()
                    } else if self?.nextPage == CommonConstants.SIGN_UP_NEXT_PAGE_CODE {
                        self?.navigator.navigateToSignUp1(phoneNumber: self?.phoneNumber ?? "", country: self?.country ?? Country())
                    }
                }
            }
            
        }
    }
    
}

extension PhoneVerificationVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case digit1:
            if digit1.text!.count == 0 {
                print(string)
                digit1.text = string
                digit2.becomeFirstResponder()
                return true
            } else if digit1.text!.count == 1 && "" != string {
                print(string)
                digit1.resignFirstResponder()
                digit2.becomeFirstResponder()
                return false
            }
            
        case digit2:
            if digit2.text!.count == 0 {
                print(string)
                digit2.text = string
                digit3.becomeFirstResponder()
                return true
            } else if digit2.text!.count == 1 && "" != string {
                print(string)
                digit2.resignFirstResponder()
                digit3.becomeFirstResponder()
                return false
            }
            
        case digit3:
            if digit3.text!.count == 0 {
                print(string)
                digit3.text = string
                digit4.becomeFirstResponder()
                return true
            } else if digit3.text!.count == 1 && "" != string {
                print(string)
                digit3.resignFirstResponder()
                digit4.becomeFirstResponder()
                return false
            }
            
        case digit4:
            if digit4.text!.count == 0 {
                print(string)
                digit4.text = string
                digit5.becomeFirstResponder()
                return true
            } else if digit4.text!.count == 1 && "" != string {
                print(string)
                digit4.resignFirstResponder()
                digit5.becomeFirstResponder()
                return false
            }
            
        case digit5:
            if digit5.text!.count == 0 {
                print(string)
                digit5.text = string
                digit6.becomeFirstResponder()
                return true
            } else if digit6.text!.count == 1 && "" != string {
                print(string)
                digit5.resignFirstResponder()
                digit6.becomeFirstResponder()
                return false
            }
            
        case digit6:
            if digit6.text!.count == 0 {
                print(string)
                digit6.text = string
                dismissKeyboard()
                return true
            } else if digit6.text!.count == 1 && "" != string {
                print(string)
                digit6.resignFirstResponder()
                dismissKeyboard()
                return false
            }
            
        default:
            return true
        }
        return true
    }
}

extension PhoneVerificationVC: PhoneVerificationView {
    func loginSuccess(user: User) {
        
    }
    
    func failed(errorMessage: String) {
        self.view.makeToast(errorMessage)
    }
    
    func handleNoInternetConnection() {
        self.view.makeToast("noInternetConnection".localized())
    }
}
