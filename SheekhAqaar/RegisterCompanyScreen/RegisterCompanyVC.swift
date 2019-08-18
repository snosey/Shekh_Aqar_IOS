//
//  RegisterCompanyVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/18/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

class RegisterCompanyVC: BaseVC {

    public class func buildVC() -> RegisterCompanyVC {
        let storyboard = UIStoryboard(name: "RegisterCompanyStoryboard", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "RegisterCompanyVC") as! RegisterCompanyVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
