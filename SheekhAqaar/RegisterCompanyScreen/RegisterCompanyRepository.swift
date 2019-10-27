//
//  RegisterCompanyRepository.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/26/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyUserDefaults
import Localize_Swift

public protocol RegisterCompanyPresenterDelegate: class {
    func registerCompanySuccess(user: User)
    func failed(errorMessage: String)
}

public class RegisterCompanyRepository {
    var delegate: RegisterCompanyPresenterDelegate!
    
    public func setDelegate(delegate: RegisterCompanyPresenterDelegate) {
        self.delegate = delegate
    }
    
    public func registerCompany(userPhoneNumber: String, userName: String, userImage: Data, companyImage: Data, companyServices: [Category], companyName: String, companyTraditionalNumber: String, companyPhoneNumber: String, companyEmail: String, companyCountry: Country, companyRegion: Region, detailedAddress: String, companyLatitude: Double, companyLongitude: Double, userSelectedCountry: Country, companySelectedCountry: Country) {
        
        let user = User()
        if let _ = Defaults[.user] {
            user.id = User(json: Defaults[.user]!)?.id
            user.token = User(json: Defaults[.user]!)?.token
        }
        user.countryId = userSelectedCountry.id
        user.name = userName
        user.phoneNumber = "+" + userSelectedCountry.code + userPhoneNumber
        user.language = 0
        user.userType = UserType.USER.rawValue
        
        
        let company = Company()
        company.regionId = companyRegion.id
        company.name = companyName
        company.commercialNumber = Int(companyTraditionalNumber)!
        company.phoneNumber =  "+" + companySelectedCountry.code + companyPhoneNumber
        company.email = companyEmail
        company.address = detailedAddress
        company.latitude = String(companyLatitude)
        company.longitude = String(companyLongitude)
        company.numberOfAds = 0
        company.companyTypes = []
        company.userId = user.id
        
        let url = CommonConstants.BASE_URL + "Company/SignUp"
        
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
                    let serviceDic = service.toJSON()! as! Dictionary<String, AnyObject>
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
                            self.delegate.registerCompanySuccess(user: user)
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
