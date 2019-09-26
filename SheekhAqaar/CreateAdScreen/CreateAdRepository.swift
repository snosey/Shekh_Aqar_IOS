//
//  CreateAdRepository.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/2/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyUserDefaults

public protocol CreateAdPresenterDelegate: class {
    func getCreateAdDataSuccess(createAdData: CreateAdData)
    func publishAdSuccess()
    func failed(errorMessage: String)
}

public class CreateAdRepository {
    var delegate: CreateAdPresenterDelegate!
    
    public func setDelegate(delegate: CreateAdPresenterDelegate) {
        self.delegate = delegate
    }
    
    func getCreateAdData(subCategoryId: Int, latitude: Double, longitude: Double) {
        let url = CommonConstants.BASE_URL + "User/AddAds"
        let parameters = ["Fk_SubCategory" : subCategoryId, "Latitude" : latitude, "Longitude" : longitude] as [String : Any]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                switch response.result {
                case .success(_):
                    let json = (response.result.value as! Dictionary<String,AnyObject>)
                    let statusObj = json["Status"] as! Dictionary<String,AnyObject>
                    
                    if let id = statusObj["Id"] as? Int, id == 1 {
                        let createAdDataJsonObj = json["Data"] as! Dictionary<String,AnyObject>
                        if let createAdData = CreateAdData(json: createAdDataJsonObj) {
                            self.delegate.getCreateAdDataSuccess(createAdData: createAdData)
                        } else {
                            self.delegate.failed(errorMessage: "Parsing Error")
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
    
    public func publishAd(adTitle: String, additionalFacilities: [String], adDetailsItems: [String], images: [Data]) {
        let url = CommonConstants.BASE_URL + "User/AddAds"
        
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                if images.count == 1 {
                    let data = images[0]
                    MultipartFormData.append(data, withName: "ImgFile", fileName: "file.jpg", mimeType:"image/*")
                } else if images.count > 1 {
                    for (index, img) in images.enumerated() {
                        let data = img
                        MultipartFormData.append(data, withName: "ImgFile", fileName: "file\(index).jpg", mimeType:"image/*")
                    }
                }else {}
                 MultipartFormData.append(adTitle.data(using: .utf8)!, withName: "UserItemString")
                 let jsonArr1 = try? JSONEncoder().encode(additionalFacilities)
                MultipartFormData.append(jsonArr1!, withName: "UserItemFeatureString")
                 let jsonArr2 = try? JSONEncoder().encode(adDetailsItems)
                 MultipartFormData.append(jsonArr2!, withName: "UserItemMainString")
                guard let token = User(json: Defaults[.user]!)?.token else {
                    return
                }
                MultipartFormData.append("\(token)".data(using: .utf8)!, withName: "token")

        }, to: url) { (result) in

            switch result {
            case .success(_, _, _):
                print(result)
                self.delegate.publishAdSuccess()
                break

            case .failure(let error):
                self.delegate.failed(errorMessage: error.localizedDescription)
                break
            }

        }
    }
}
