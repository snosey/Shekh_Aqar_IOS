//
//  AdRepository.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/30/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyUserDefaults

public protocol MyAdsPresenterDelegate: class {
    func getMyAdsSuccess(ads: [Ad])
    func failed(errorMessage: String)
}


public class MyAdsRepository {
    var delegate: MyAdsPresenterDelegate!
    
    public func setDelegate(delegate: MyAdsPresenterDelegate) {
        self.delegate = delegate
    }
    
    public func getMyAds() {
        let user = User(json: Defaults[.user]!)!
        let params = ["Fk_User" : user.id] as [String : Any]
        let url = CommonConstants.BASE_URL + "User/GetAds"
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                switch response.result {
                case .success(_):
                    let json = (response.result.value as! Dictionary<String,AnyObject>)
                    let statusObj = json["Status"] as! Dictionary<String,AnyObject>
                    
                    if let id = statusObj["Id"] as? Int, id == 1 {
                        let adsJsonArray = json["Data"] as! [Dictionary<String,AnyObject>]
                        var ads = [Ad]()
                        for adJsonObj in adsJsonArray {
                            let ad = Ad(json: adJsonObj)
                            ads.append(ad!)
                        }
                        self.delegate.getMyAdsSuccess(ads: ads)
                    } else {
                        self.delegate.failed(errorMessage: statusObj["Message"] as! String)
                    }
                    
                    break
                    
                case .failure(let error):
                    self.delegate.failed(errorMessage: error.localizedDescription)
                    break
                }
        }
        
    }
}
