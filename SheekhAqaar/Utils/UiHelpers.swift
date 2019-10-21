//
//  UiHelpers.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/17/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import NVActivityIndicatorView
import SystemConfiguration
import SideMenu
import Localize_Swift
import GoogleMaps
import Alamofire

class UiHelpers {

    class func makeMarkerView(sourceView: UIView, companyName: String, adsNumber: Int, companyColorCode: String) -> UIView {
        
        let topView = UIView()
        let bottomImageView = UIImageView(image: UIImage(named: "marker_bottom"))
        
        let companyNameLabel = UILabel()
        companyNameLabel.backgroundColor = .clear
        companyNameLabel.text = companyName
        companyNameLabel.textAlignment = .center
        companyNameLabel.textColor = UIColor(hexString: "#1E1C21")
        companyNameLabel.fontSize = 10
        
        let adsNumberLabel = UILabel()
        adsNumberLabel.backgroundColor = .clear
        adsNumberLabel.text = "\("adsNumber".localized()) \(adsNumber)"
        adsNumberLabel.textAlignment = .center
        adsNumberLabel.textColor = UIColor(hexString: "#1E1C21")
        adsNumberLabel.fontSize = 10
        
        let sourceView = UIView(superView: sourceView, padding: 0)
        sourceView.backgroundColor = .clear
        
        sourceView.addSubviews([topView, bottomImageView, companyNameLabel, adsNumberLabel])
        sourceView.size.width = UiHelpers.getLengthAccordingTo(relation: .SCREEN_WIDTH, relativeView: nil, percentage: 22)
        sourceView.size.height = UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 10)


        topView.clipsToBounds = true
        topView.layer.cornerRadius = 8
        topView.backgroundColor = UIColor(hexString: companyColorCode)
        
        topView.addSubview(companyNameLabel)
        
        bottomImageView.addSubview(adsNumberLabel)
        
        topView.snp.makeConstraints { (maker) in
            maker.top.equalTo(sourceView)
            maker.centerX.equalTo(sourceView)
            maker.height.equalTo(UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 5))
            maker.width.equalTo(UiHelpers.getLengthAccordingTo(relation: .SCREEN_WIDTH, relativeView: nil, percentage: 21))
        }
        
        companyNameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(topView)
            maker.centerX.equalTo(topView)
            maker.height.equalTo(topView)
            maker.width.equalTo(topView)
        }

        bottomImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(topView.snp.bottom).offset(-8)
            maker.centerX.equalTo(sourceView)
            maker.height.equalTo(UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 5))
            maker.width.equalTo(sourceView)
        }
        
        adsNumberLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(bottomImageView).offset(-8)
            maker.centerX.equalTo(sourceView)
            maker.height.equalTo(bottomImageView)
            maker.width.equalTo(bottomImageView)
        }
        
        sourceView.bringSubviewToFront(bottomImageView)
        return sourceView
    }
    
    class func addCompanyMarker(sourceView: UIView, latitude: Double, longitude: Double, title: String, adsNumber: Int, mapView: GMSMapView, companyMarkerColor: String) -> GMSMarker {
        let locationMarker = GMSMarker()
        locationMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        locationMarker.title = title
        locationMarker.iconView = UiHelpers.makeMarkerView(sourceView: sourceView, companyName: title, adsNumber: adsNumber, companyColorCode: companyMarkerColor)
        locationMarker.map = mapView
        return locationMarker
    }
    
    class func addMarker(latitude: Double, longitude: Double, title: String, markerView: UIView?, mapView: GMSMapView) {
        let locationMarker = GMSMarker()
        locationMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        locationMarker.title = title
        locationMarker.iconView = markerView
        locationMarker.map = mapView
    }
    
    class func showLoader() {
        let activityData = ActivityData(size: nil, message: nil, messageFont: nil, messageSpacing: nil, type: nil, color: UIColor.AppColors.darkGray, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: nil)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
    }
    
    class func hideLoader() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
    
    class func createAlertView(title: String, message: String, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        for action in actions {
            alert.addAction(action)
        }
        return alert
    }
    
    class func getLengthAccordingTo(relation: LengthRelation, relativeView: UIView?, percentage: CGFloat) -> CGFloat {
        
        switch relation {
        case .SCREEN_WIDTH:
            return UIScreen.main.bounds.width * (percentage / 100)
            
        case .SCREEN_HEIGHT:
            return UIScreen.main.bounds.height * (percentage / 100)
            
        case .VIEW_WIDTH:
            if let view = relativeView {
                return view.frame.size.width * (percentage / 100)
            }
            return 0
            
        case .VIEW_HEIGHT:
            if let view = relativeView {
                return view.frame.size.height * (percentage / 100)
            }
            return 0
        }
    }
    
    class func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let isConnected = (isReachable && !needsConnection)
        return isConnected
        
    }
    
    class func share(textToShare: String, sourceView: UIView, vc: BaseVC) {
        
        // set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sourceView // so that iPads won't crash
        
        // present the view controller
        vc.present(activityViewController, animated: true, completion: nil)
        
    }
    
    class func getAddressFromLocation(latitude: Double, longitude: Double, completion: @escaping (String, String?, Bool)->()) {
        let parameters = [
            "latlng" : "\(latitude),\(longitude)",
            "sensor" : true,
            "language" : Localize.currentLanguage(),
            "key" : CommonConstants.GOOGLE_MAPS_KEY] as [String : Any]
        
        Alamofire.request("https://maps.googleapis.com/maps/api/geocode/json", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
            case .success(_):
                if let json = (response.result.value as? Dictionary<String,AnyObject>) {
                    if let results = json["results"] as? [Dictionary<String,AnyObject>], results.count > 0 {
                        var address = ""
                        var country: String?
                        let result = results[0]
                        if let address1 = result["formatted_address"] as? String {
                            address = address1
                        }
                        if let addressComponents = json["address_components"] as? [Dictionary<String,AnyObject>] {
                            for addressComponent in addressComponents {
                                if let types = addressComponent["types"] as? [String] {
                                    for type in types {
                                        if type == "country" {
                                            country = addressComponent["short_name"] as? String
                                        }
                                    }
                                }
                            }
                        }
                        
                        if country == "" {
                            completion(address, nil, true)
                        } else {
                            completion(address, country, true)
                        }
                    }
                } else {
                    completion("", nil, false)
                }
                break
                
            case .failure(let error):
                completion(error.localizedDescription, nil, false)
                break
            }
        }
    }
    
    class func shareImage(sharableImage: UIImage, sourceView: UIView, vc: BaseVC) {
        let activityViewController = UIActivityViewController(activityItems : [sharableImage], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sourceView
        
        vc.present(activityViewController, animated: true, completion: nil)
    }
    
    class func makeCall(phoneNumber: String) {
        let urlString = "telprompt://\(phoneNumber)"
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    class func openWahtsApp(view: UIView, phoneNumber: String) {
        let appURL = NSURL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(appURL as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL as URL)
            }
        } else {
            view.makeToast("downloadWhatsApp".localized())
        }
    }
    
    class func openMail(email: String) {
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    class func openGoogleMaps(view: UIView, latitude: Double, longitude: Double) {
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://") as! URL)) {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving") as! URL)
        } else {
           view.makeToast("downloadGoogleMaps".localized())
        }
    }
    
    class func setupSideMenu(delegate: UISideMenuNavigationControllerDelegate, viewToPresent: UIView, viewToEdge: UIView, sideMenuCellDelegate: SideMenuCellDelegate?, sideMenuHeaderDelegate: SideMenuHeaderDelegate?) -> SideMenuVC {
        
        let sideMenuVC = SideMenuVC.buildVC()
        sideMenuVC.sideMenuCellDelegate = sideMenuCellDelegate
        sideMenuVC.sideMenuHeaderDelegate = sideMenuHeaderDelegate
        
        let menuNavigationController = UISideMenuNavigationController(rootViewController: sideMenuVC)
        menuNavigationController.sideMenuDelegate = delegate
        menuNavigationController.menuWidth = UiHelpers.getLengthAccordingTo(relation: .SCREEN_WIDTH, relativeView: nil, percentage: 70)
        if Localize.currentLanguage() == "ar" {
            SideMenuManager.default.menuRightNavigationController = menuNavigationController
        } else {
            SideMenuManager.default.menuLeftNavigationController = menuNavigationController
        }
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: viewToPresent)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: viewToEdge)
        return sideMenuVC
    }
    
    public class func compareDates(date1: Date, date2: Date) -> DateComparisonResult {
        if date1 > date2 {
            return .FIRST_GREATER
        } else if date2 > date1 {
            return .SECOND_GREATER
        } else {
            return .EQUAL
        }
    }
    
    public class func convertDateToString(date: Date, dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
    
    public class func convertStringToDate(string: String, dateFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from:string)!
        return date
    }
    
    class func makeLabelUnderlined(label: UILabel) {
        let text = label.text
        let textRange = NSRange(location: 0, length: (text?.count)!)
        let attributedText = NSMutableAttributedString(string: text!)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: textRange)
        label.attributedText = attributedText
    }
}

public enum LengthRelation: Int {
    case SCREEN_WIDTH = 0
    case SCREEN_HEIGHT = 1
    case VIEW_WIDTH = 2
    case VIEW_HEIGHT = 3
}

public enum DateComparisonResult: Int {
    case FIRST_GREATER = 0
    case SECOND_GREATER = 1
    case EQUAL = 2
}

extension Date {
    func timeAgoDisplay() -> String {
        
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\("from".localized()) \(diff) \("sec".localized())"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\("from".localized()) \(diff) \("min".localized())"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\("from".localized()) \(diff) \("hr".localized())"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\("from".localized()) \(diff) \("days".localized())"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "\("from".localized()) \(diff) \("weeks".localized())"
    }
}

extension Dictionary {
    public func toString() -> String {
        
        var result = "{"
        
        for (key, value) in self {
            if value is String {
                result = result + "\"\(key)\"" + ":" + "\"\(value)\"" + ","
            } else if value is [Dictionary] {
                var jsonArrayString = "["
                if (value as! [Dictionary]).count > 0 {
                    for dict in (value as! [Dictionary]) {
                        jsonArrayString = jsonArrayString + dict.toString() + ","
                    }
                    jsonArrayString.removeLast()
                }
                jsonArrayString = jsonArrayString + "]"
                result = result + "\"\(key)\"" + ":" + "\(jsonArrayString)" + ","
            } else if value is Dictionary {
                let jsonObjectString = (value as! Dictionary).toString()
                result = result + "\"\(key)\"" + ":" + jsonObjectString + ","
            } else if value is DataType {
                let dic = (value as! DataType).toJSON()!
                let jsonObjectString = (dic as! Dictionary).toString()
                result = result + "\"\(key)\"" + ":" + jsonObjectString + ","
            } else {
                result = result + "\"\(key)\"" + ":" + "\(value)" + ","
            }
            
        }
        
        result.removeLast()
        
        result = result + "}"
        result = result.replacingOccurrences(of: "(", with: "[")
        result = result.replacingOccurrences(of: ")", with: "]")
//        print(result)
        return result
    }
}
