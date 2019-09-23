//
//  HelpRepository.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/23/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyUserDefaults

public protocol HelpPresenterDelegate: class {
    func getHelpDateSuccess(helpData: HelpData)
    func failed(errorMessage: String)
}

public class HelpRepository {
    var delegate: HelpPresenterDelegate!
    
    public func setDelegate(delegate: HelpPresenterDelegate) {
        self.delegate = delegate
    }
    
    public func getHelpData() {
        let url = CommonConstants.BASE_URL + "User/GetSupportData"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                switch response.result {
                case .success(_):
                    let json = (response.result.value as! Dictionary<String,AnyObject>)
                    let statusObj = json["Status"] as! Dictionary<String,AnyObject>
                    
                    if let id = statusObj["Id"] as? Int, id == 1 {
                        let helpJsonObj = json["Data"] as! Dictionary<String,AnyObject>
                        if let helpData = HelpData(json: helpJsonObj) {
                            self.delegate.getHelpDateSuccess(helpData: helpData)
                        } else {
                             self.delegate.failed(errorMessage: "Parsing error")
                        }
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
