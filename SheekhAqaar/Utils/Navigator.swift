//
//  Navigator.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/17/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import UIKit

public class Navigator {
    
    var navigationController: UINavigationController!
    
    public init(navController: UINavigationController) {
        self.navigationController = navController
    }
    
    public func navigateToSignUp1(phoneNumber: String) {
        weak var vc = SignUp1VC.buildVC(phoneNumber: phoneNumber)
        if let vc = vc {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
}
