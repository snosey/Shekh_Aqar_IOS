//
//  EditCompanyRepository.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 10/5/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Alamofire

import SwiftyUserDefaults

public protocol EditCompanyPresenterDelegate: class {
    func getCompanySuccess(company: Company)
    func editCompanySuccess(user: User)
    func failed(errorMessage: String)
}

public class EditCompanyRepository {
    var delegate: EditCompanyPresenterDelegate!
    
    public func setDelegate(delegate: EditCompanyPresenterDelegate) {
        self.delegate = delegate
    }
    
    public func getCompany(companyId: Int) {
        let params = ["Fk_Company" : companyId, "Token" : User(json: Defaults[.user]!)!.token!] as [String : Any]
        let url = CommonConstants.BASE_URL + "User/GetCompany"
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                switch response.result {
                case .success(_):
                    let json = (response.result.value as! Dictionary<String,AnyObject>)
                    let statusObj = json["Status"] as! Dictionary<String,AnyObject>
                    
                    if let id = statusObj["Id"] as? Int, id == 1 { // should be 1
                        
                        let dataObj = json["Data"] as! Dictionary<String,AnyObject>
                        let company = Company(json: dataObj)!
                        
                        var companyTypes = [CompanyType]()
                        
                        let companyTypesJsonArray = dataObj["CompanyTypesModel"] as! [Dictionary<String, AnyObject>]
                        
                        for companyTypeJsonObj in companyTypesJsonArray {
                            let companyType = CompanyType(json: companyTypeJsonObj)
                            companyTypes.append(companyType!)
                        }
                        
                        company.companyTypes = companyTypes
                        
//                        var count = 0
//
//                        for facility in ad.additionalFacilities {
//                            facility.itemFeatureModel = ItemFeatureModel(json: ((dataObj["UserItemFeaturesModel"] as! [Dictionary<String, AnyObject>])[count])["ItemFeatureModel"] as! Dictionary<String, AnyObject>)
//                            count = count + 1
//                        }
                        self.delegate.getCompanySuccess(company: company)
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
    
    public func editCompany(userPhoneNumber: String, userName: String, userImage: Data, companyImage: Data, companyServices: [Category], companyName: String, companyTraditionalNumber: String, companyPhoneNumber: String, companyEmail: String, companyCountry: Country, companyRegion: Region, detailedAddress: String, companyLatitude: Double, companyLongitude: Double, userSelectedCountry: Country, companySelectedCountry: Country) {
        
        let url = CommonConstants.BASE_URL + "Company/SignUp"
        
        let user = User()
        user.countryId = userSelectedCountry.id
        user.name = userName
        user.phoneNumber = userPhoneNumber
        user.language = 0
        user.userType = UserType.USER.rawValue
        
        let company = Company()
        company.regionId = companyRegion.id
        company.name = companyName
        company.commercialNumber = Int(companyTraditionalNumber)!
        company.phoneNumber = companyPhoneNumber
        company.email = companyEmail
        company.address = detailedAddress
        company.latitude = String(companyLatitude)
        company.longitude = String(companyLongitude)
        
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                MultipartFormData.append(userImage, withName: "ImgFile", fileName: "file1.jpg", mimeType:"image/*")
                MultipartFormData.append(companyImage, withName: "ImgFile2", fileName: "file2.jpg", mimeType:"image/*")
                
                let userDic = user.toJSON()!
                MultipartFormData.append((userDic.toString().data(using: String.Encoding.utf8, allowLossyConversion: false)!), withName :"UserModel")
                
                let companyDic = company.toJSON()!
                MultipartFormData.append((companyDic.toString().data(using: String.Encoding.utf8, allowLossyConversion: false)!), withName :"CompanyModel")
                
                var jsonArrayResult = "["
                for service in companyServices {
                    let serviceDic = service.toJSON()!
                    jsonArrayResult = jsonArrayResult + serviceDic.toString() + ","
                }
                
                jsonArrayResult.removeLast()
                jsonArrayResult = jsonArrayResult + "]"
                jsonArrayResult = jsonArrayResult.replacingOccurrences(of: "\\", with: "")
                
                MultipartFormData.append((jsonArrayResult.data(using: String.Encoding.utf8, allowLossyConversion: false)!), withName :"OrgTypeModel")
                
        }, to: url) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                print(result)
                upload.responseJSON { response in
                    let json = (response.result.value as! Dictionary<String,AnyObject>)
                    let status = Status(json: json["Status"] as! Dictionary<String, AnyObject>)!
                    if status.id == 1 {
                        if let user = User(json: json["Data"] as! Dictionary<String,AnyObject>) {
                            self.delegate.editCompanySuccess(user: user)
                        } else {
                            self.delegate.failed(errorMessage: "Parsing error in user")
                        }
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
