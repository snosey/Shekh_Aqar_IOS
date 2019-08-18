//
//  BaseVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/17/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import UIKit

class BaseVC: UIViewController {
    
    public var navigator: Navigator!
    /**
     This method is called when any child ViewController's view loaded, Initialize the navigator object and set the status bar style .
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenClick()
        if let navController = self.navigationController  {
            navigator = Navigator(navController: navController)
        }
        
//        if !(self is TripClaimsVC){
//            setStatusBarWithBlackStyle()
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let navController = self.navigationController  {
            navigator = Navigator(navController: navController)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
//        if self is SplashVC || self is HomeVC || self is DestinationVC || self is TripConfirmationVC || self is AtCustomerVC || self is DriverOnTheWayVC || self is ToDestinationVC {
//            return .default
//        } else {
            return .lightContent
//        }
    }
    
    /**
     This method is called when any child ViewController's will disappear, Removes the title of the navigation bar title .
     - Parameter animated: Indicates that the screen will disapear with animation or not.
     */
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // needed to clear the text in the back navigation:
        self.navigationItem.title = " "
    }
}
