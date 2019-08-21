//
//  PhoneVerificationVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/18/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

class PhoneVerificationVC: BaseVC {

    public class func buildVC(phoneNumber: String) -> PhoneVerificationVC {
        let storyboard = UIStoryboard(name: "PhoneVerificationStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PhoneVerificationVC") as! PhoneVerificationVC
        vc.phoneNumber = phoneNumber
        return vc
    }
    
    @IBOutlet weak var digit1: UITextField!
    @IBOutlet weak var digit2: UITextField!
    @IBOutlet weak var digit3: UITextField!
    @IBOutlet weak var digit4: UITextField!
    @IBOutlet weak var resendCodeLabel: LocalizedLabel!
    @IBOutlet weak var backLabel: LocalizedLabel!
    @IBOutlet weak var confirmButton: LocalizedButton!
    
    
    var phoneNumber: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UiHelpers.makeLabelUnderlined(label: resendCodeLabel)
        UiHelpers.makeLabelUnderlined(label: backLabel)
        
        resendCodeLabel.addTapGesture { [weak self](_) in
            
        }
        
        backLabel.addTapGesture { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        digit1.delegate = self
        digit2.delegate = self
        digit3.delegate = self
        digit4.delegate = self
        
        digit1.becomeFirstResponder()
        
        GradientBG.createGradientLayer(view: confirmButton, cornerRaduis: 8, maskToBounds: true)
    }

    @IBAction func confirmClicked(_ sender: Any) {
        
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
                dismissKeyboard()
                return true
            } else if digit4.text!.count == 1 && "" != string {
                print(string)
                digit4.resignFirstResponder()
                dismissKeyboard()
                return false
            }
            
        default:
            return true
        }
        return true
    }
}
