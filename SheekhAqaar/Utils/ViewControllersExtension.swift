//
//  ViewControllersExtension.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/17/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift

extension UIViewController {
    
    func hideKeyboardWhenClick() {
        self.view.addTapGesture { [weak self] recognizer in
            self?.dismissKeyboard()
        }
    }
    
    func setNavBarTitle(title:String,withColor color :UIColor,  tintColor :UIColor ) {
        let titleView = UILabel(frame:CGRect(x: 0, y: 0, width: 34, height: 34))
        titleView.font = AppFont.font(type: .Bold, size: 15)
        titleView.text = title
        titleView.textColor = color
        self.navigationItem.titleView = titleView
        self.navigationController!.navigationBar.tintColor = tintColor
    }
    
    func setStatusBarWithWhiteStyle() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    func setStatusBarWithBlackStyle() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    func setNavigationItemHiddenTitle (title:String) {
        self.navigationItem.title = title
        if let barTintColor = self.navigationController?.navigationBar.barTintColor{
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: barTintColor]
        }
    }
    
    func setSecondStatusBar() {
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor.AppColors.primaryColor
    }
    
    func setBackButton() {
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back button")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back button")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setStyle(style: .solidNoShadow, tintColor: UIColor.AppColors.gray, forgroundColor: .white)
        
    }
    
    func setDefaultStatusBar() {
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor.white
    }
}

extension UIImageView {
    // function to get the proper height of image relative to the image width of screen
    //then update the constraint of height of UIImageview to the returned value
    
    func GetApectRatioHeight(ImageView:UIImageView)->CGFloat{
        let screenWidth = UIScreen.main.bounds.width
        
        if ImageView.image == nil {
            
            return 0
            
        }else {
            let ImageWidth = ImageView.image?.size.width
            let AspectRatio = (screenWidth/ImageWidth!) * (ImageView.image?.size.height)!
            return AspectRatio
        }
        
    }
}
extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
extension UIView {
    
    
    public func makeToast(_ message: String,duration:TimeInterval, myCompletion:(() -> Void)?) {
        var style = ToastStyle()
        style.titleAlignment = .center
        style.messageAlignment = .center
        self.makeToast(message, duration: duration, position: .bottom, title: nil, image: nil, style: style) { (_) in
            myCompletion?()
        }
    }
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
