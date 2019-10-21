//
//  RequestBuildingRepository.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/29/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Alamofire
import SwiftyUserDefaults
import SwiftyJSON

public protocol RequestBuildingPresenterDelegate: class {
    func getRequestBuildingDataSuccess(createAdData: CreateAdData)
    func requestBuildingSuccess()
    func failed(errorMessage: String)
}

public class RequestBuildingRepository {
    var delegate: RequestBuildingPresenterDelegate!
    
    public func setDelegate(delegate: RequestBuildingPresenterDelegate) {
        self.delegate = delegate
    }
    
    func getRequestBuildingData(subCategoryId: Int, latitude: Double, longitude: Double) {
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
                            self.delegate.getRequestBuildingDataSuccess(createAdData: createAdData)
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
    
    public func requestBuilding(ad: Ad, adDetailsItems: [AdDetailsItem]) {
        let url = CommonConstants.BASE_URL + "User/AddAds?token=\(User(json: Defaults[.user]!)!.token!)"
        
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
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
                upload.responseJSON { response in
                    let json = (response.result.value as! Dictionary<String,AnyObject>)
                    let status = Status(json: json["Status"] as! Dictionary<String, AnyObject>)!
                    if status.id == 1 {
                        self.delegate.requestBuildingSuccess()
                    } else {
                        self.delegate.failed(errorMessage: (status.message)!)
                    }
                }
                break
                
            case .failure(let error):
                self.delegate.failed(errorMessage: error.localizedDescription)
                break
            }
            
        }
    }
}

