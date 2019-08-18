//
//  SignUp1VC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/18/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

class SignUp1VC: BaseVC {

    public class func buildVC(phoneNumber: String) -> SignUp1VC {
        let storyboard = UIStoryboard(name: "SignUp1Storyboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUp1VC") as! SignUp1VC
        vc.phoneNumber = phoneNumber
        return vc
    }
    
    var phoneNumber: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
