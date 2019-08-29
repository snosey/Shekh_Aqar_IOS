//
//  HelpVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/27/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

class HelpVC: BaseVC {

    public class func buildVC() -> HelpVC {
        let storyboard = UIStoryboard(name: "HelpStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HelpVC") as! HelpVC
        return vc
    }
    
    @IBOutlet weak var backIcon: UIImageView!
    @IBOutlet weak var twitterImageView: UIImageView!
    @IBOutlet weak var facebookImageView: UIImageView!
    @IBOutlet weak var instagramImageView: UIImageView!
    
    let phoneNumber =  "+989160000000"
    let email = "heshamkhaled92@gmail.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backIcon.addTapGesture { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        twitterImageView.addTapGesture { (_) in
            let appURL = NSURL(string: "https://www.twitter.com")!
            if UIApplication.shared.canOpenURL(appURL as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL as URL)
                }
            }
        }
        
        facebookImageView.addTapGesture { (_) in
            let appURL = NSURL(string: "https://www.facebook.com")!
            if UIApplication.shared.canOpenURL(appURL as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL as URL)
                }
            }
        }
        
        instagramImageView.addTapGesture { (_) in
            let appURL = NSURL(string: "https://www.instagram.com")!
            if UIApplication.shared.canOpenURL(appURL as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL as URL)
                }
            }
        }
    }
    
    @IBAction func whatsAppClicked(_ sender: Any) {
        
        let appURL = NSURL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(appURL as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL as URL)
            }
        } else {
            self.view.makeToast("downloadWhatsApp".localized())
        }
    }
    
    @IBAction func emailClicked(_ sender: Any) {
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func callClicked(_ sender: Any) {
        let urlString = "telprompt://\(phoneNumber)"
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}
