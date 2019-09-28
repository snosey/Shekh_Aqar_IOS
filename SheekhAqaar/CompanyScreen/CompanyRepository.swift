//
//  CompanyRepository.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/27/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Alamofire

public protocol CompanyPresenterDelegate: class {
    func getCompanyAdsSuccess(ads: [Ad])
    func failed(errorMessage: String)
}


public class CompanyRepository {
    var delegate: CompanyPresenterDelegate!
    
    public func setDelegate(delegate: CompanyPresenterDelegate) {
        self.delegate = delegate
    }
    
    public func getCompanyAds(companyId: Int) {
        let params = ["Fk_Company" : companyId] as [String : Any]
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
                        self.delegate.getCompanyAdsSuccess(ads: ads)
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
