//
//  EditAdRepository.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 10/2/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyUserDefaults

public protocol EditAdPresenterDelegate: class {
    func getCreateAdDataSuccess(createAdData: CreateAdData)
    func editAdSuccess()
    func failed(errorMessage: String)
}

public class EditAdRepository {
    var delegate: EditAdPresenterDelegate!
    
    public func setDelegate(delegate: EditAdPresenterDelegate) {
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
    
    public func editAd(ad: Ad, adDetailsItems: [AdDetailsItem], images: [Data], imagesToBeRemoved: [Data]) {
        var url = CommonConstants.BASE_URL + "User/EditAds"
        
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
                }
                
                if imagesToBeRemoved.count == 1 {
                    let data = imagesToBeRemoved[0]
                    MultipartFormData.append(data, withName: "RmvImgFile", fileName: "fileRemoved.jpg", mimeType:"image/*")
                } else if imagesToBeRemoved.count > 1 {
                    for (index, img) in imagesToBeRemoved.enumerated() {
                        let data = img
                        MultipartFormData.append(data, withName: "RmvImgFile", fileName: "fileRemoved.jpg\(index).jpg", mimeType:"image/*")
                    }
                }
                
                let adJsonObject = try? JSONSerialization.data(withJSONObject: ad.toJSON()!, options: JSONSerialization.WritingOptions(rawValue: 0))
                MultipartFormData.append(adJsonObject!, withName: "UserItemString")
                
                let additionalFacilities = ad.additionalFacilities
                
                var additionalFacilitiesJsonArray = [Data]()
                var adDetailsItemsJsonArray = [Data]()
                
                for facility in additionalFacilities ?? [] {
                    let facilityJsonObject = try? JSONSerialization.data(withJSONObject: facility.toJSON()!, options: JSONSerialization.WritingOptions(rawValue: 0))
                    additionalFacilitiesJsonArray.append(facilityJsonObject!)
                    
                }
                
                for adDetailsItem in adDetailsItems {
                    let itemJsonObject = try? JSONSerialization.data(withJSONObject: adDetailsItem.toJSON()!, options: JSONSerialization.WritingOptions(rawValue: 0))
                    adDetailsItemsJsonArray.append(itemJsonObject!)
                }
                
                let jsonArr1 = try? JSONEncoder().encode(additionalFacilitiesJsonArray)
                MultipartFormData.append(jsonArr1!, withName: "UserItemFeatureString")
                
                let jsonArr2 = try? JSONEncoder().encode(adDetailsItemsJsonArray)
                MultipartFormData.append(jsonArr2!, withName: "UserItemMainString")
                guard let token = User(json: Defaults[.user]!)?.token else {
                    return
                }
                url = url + "?token=\(token)"
                
        }, to: url) { (result) in
            
            switch result {
            case .success(_, _, _):
                print(result)
                self.delegate.editAdSuccess()
                break
                
            case .failure(let error):
                self.delegate.failed(errorMessage: error.localizedDescription)
                break
            }
            
        }
    }
}
