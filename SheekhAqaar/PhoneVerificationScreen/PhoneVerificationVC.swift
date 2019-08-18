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
    
    var phoneNumber: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
