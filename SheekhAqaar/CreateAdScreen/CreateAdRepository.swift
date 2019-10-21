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
    
    public func publishAd(ad: Ad, adDetailsItems: [AdDetailsItem], images: [Data]) {
        var url = CommonConstants.BASE_URL + "User/AddAds"
        guard let token = User(json: Defaults[.user]!)?.token else {
            return
        }
        url = url + "?token=\(token)"
        print(url)
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                if images.count == 1 {
                    let data = images[0]
                    MultipartFormData.append(data, withName: "ImgFile", fileName: "file.jpg", mimeType:"image/*")
                } else if images.count > 1 {
                    for (index, img) in images.enumerated() {
                        let data = img
                        MultipartFormData.append(data, withName: "ImgFile[\(index)]", fileName: "file\(index).jpg", mimeType:"image/*")
                    }
                }
                
                let adDic = ad.toJSON()!
                MultipartFormData.append((adDic.toString().data(using: String.Encoding.utf8, allowLossyConversion: false)!), withName :"UserItemString")
                
                let additionalFacilities = ad.additionalFacilities
                
                
                var additionalFacilitiesJsonArrayResult = "["
                for facility in additionalFacilities ?? [] {
                    let facilityDic = facility.toJSON()!
                    additionalFacilitiesJsonArrayResult = additionalFacilitiesJsonArrayResult + facilityDic.toString() + ","
                }
                
                additionalFacilitiesJsonArrayResult.removeLast()
                additionalFacilitiesJsonArrayResult = additionalFacilitiesJsonArrayResult + "]"
                additionalFacilitiesJsonArrayResult = additionalFacilitiesJsonArrayResult.replacingOccurrences(of: "\\", with: "")
                
                MultipartFormData.append((additionalFacilitiesJsonArrayResult.data(using: String.Encoding.utf8, allowLossyConversion: false)!), withName :"UserItemFeatureString")
                
                var adDetailsItemsJsonArrayResult = "["
                for adDetailsItem in adDetailsItems {
                    let adDetailsItemDic = adDetailsItem.toJSON()!
                    adDetailsItemsJsonArrayResult = adDetailsItemsJsonArrayResult + adDetailsItemDic.toString() + ","
                }
                
                adDetailsItemsJsonArrayResult.removeLast()
                adDetailsItemsJsonArrayResult = adDetailsItemsJsonArrayResult + "]"
                adDetailsItemsJsonArrayResult = adDetailsItemsJsonArrayResult.replacingOccurrences(of: "\\", with: "")
                
                MultipartFormData.append((adDetailsItemsJsonArrayResult.data(using: String.Encoding.utf8, allowLossyConversion: false)!), withName :"UserItemMainString")
                
        }, to: url) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { (response) in
                    let json = (response.result.value as! Dictionary<String,AnyObject>)
                    let status = Status(json: json["Status"] as! Dictionary<String, AnyObject>)!
                    if status.id == 1 {
                        self.delegate.publishAdSuccess()
                    } else {
                        self.delegate.failed(errorMessage: (status.message)!)
                    }
                    print(json)
                }
                
                break
                
            case .failure(let error):
                self.delegate.failed(errorMessage: error.localizedDescription)
                break
            }
            
        }
    }
}
