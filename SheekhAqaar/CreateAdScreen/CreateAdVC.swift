//
//  CreateAdVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/30/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

class CreateAdVC: BaseVC {

    public class func buildVC() -> CreateAdVC {
        let storyboard = UIStoryboard(name: "CreateAdStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateAdVC") as! CreateAdVC
        return vc
    }
    
    @IBOutlet weak var backIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backIcon.addTapGesture { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
    }

}
