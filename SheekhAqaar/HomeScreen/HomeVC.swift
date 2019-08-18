//
//  HomeVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/18/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

class HomeVC: BaseVC {

    public class func buildVC() -> HomeVC {
        let storyboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
