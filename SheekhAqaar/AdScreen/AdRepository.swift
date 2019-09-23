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

public protocol AdPresenterDelegate: class {
    func saveFavouriteAdSuccess()
    func removeFavouriteAdSuccess()
    func failed(errorMessage: String)
}


public class AdRepository {
    var delegate: AdPresenterDelegate!
    
    public func setDelegate(delegate: AdPresenterDelegate) {
        self.delegate = delegate
    }
    
    public func saveFavouriteAd(ad: Ad) {
        let params = ["Fk_UserItem" : ad.id!, "Token" : User(json: Defaults[.user]!)!.token!] as [String : Any]
        let url = CommonConstants.BASE_URL + "User/AddFavourite"
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                switch response.result {
                case .success(_):
                    let json = (response.result.value as! Dictionary<String,AnyObject>)
                    let statusObj = json["Status"] as! Dictionary<String,AnyObject>
                    
                    if let id = statusObj["Id"] as? Int, id == 1 {
                        self.delegate.saveFavouriteAdSuccess()
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
    
    public func removeFavouriteAd(ad: Ad) {
        let params = ["Fk_UserItem" : ad.id!, "Token" : User(json: Defaults[.user]!)!.token!] as [String : Any]
        let url = CommonConstants.BASE_URL + "User/RemoveFavourite"
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                switch response.result {
                case .success(_):
                    let json = (response.result.value as! Dictionary<String,AnyObject>)
                    let statusObj = json["Status"] as! Dictionary<String,AnyObject>
                    
                    if let id = statusObj["Id"] as? Int, id == 1 {
                        self.delegate.removeFavouriteAdSuccess()
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
