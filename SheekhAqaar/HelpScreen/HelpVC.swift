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
    
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var helpData: HelpData!
    
    var presenter: HelpPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = Injector.provideHelpPresenter()
        presenter.setView(view: self)
        presenter.getHelpData()
        
        backIcon.addTapGesture { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func whatsAppClicked(_ sender: Any) {
         UiHelpers.openWahtsApp(view: self.view, phoneNumber: helpData.whatsApp)
    }
    
    @IBAction func emailClicked(_ sender: Any) {
        UiHelpers.openMail(email: helpData.email)
    }
    
    @IBAction func callClicked(_ sender: Any) {
        UiHelpers.makeCall(phoneNumber: helpData.mobile)
    }
}

extension HelpVC: HelpView {
    func getHelpDateSuccess(helpData: HelpData) {
        
        self.helpData = helpData
        
        aboutLabel.text = helpData.about
        addressLabel.text = helpData.address
        
        twitterImageView.addTapGesture { (_) in
            let appURL = NSURL(string: helpData.twitter)!
            if UIApplication.shared.canOpenURL(appURL as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL as URL)
                }
            }
        }
        
        facebookImageView.addTapGesture { (_) in
            let appURL = NSURL(string: helpData.facebook)!
            if UIApplication.shared.canOpenURL(appURL as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL as URL)
                }
            }
        }
        
        instagramImageView.addTapGesture { (_) in
            let appURL = NSURL(string: helpData.instagram)!
            if UIApplication.shared.canOpenURL(appURL as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL as URL)
                }
            }
        }
    }
    
    func failed(errorMessage: String) {
        self.view.makeToast(errorMessage)
    }
    
    func handleNoInternetConnection() {
        self.view.makeToast("noInternetConnection".localized())
    }
}
