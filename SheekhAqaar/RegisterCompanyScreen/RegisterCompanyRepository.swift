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
        
        
        
        /*
         {"CompanyModel":{"Address":"تيتيتبت","AdsCount":0,"CommercialNumber":616494,"CompanyTypesModel":[],"Email":"7aseboty@gmail.com","Fk_Location":2,"Fk_User":0,"Id":0,"Latitude":"30.4731088","Longitude":"31.1970606","Name":"ابو الخير","Phone":"61618151"},"OrgTypeModel":[{"Id":3,"Name":"مزادات","OrgLanguagesModel":[]},{"Id":1,"Name":"ادارة املاك","OrgLanguagesModel":[]},{"Id":9,"Name":"مطور عقاري","OrgLanguagesModel":[]},{"Id":6,"Name":"شركات عقاريه","OrgLanguagesModel":[]},{"Id":10,"Name":"استشارات عقارية","OrgLanguagesModel":[]},{"Id":2,"Name":"مثمن عقاري","OrgLanguagesModel":[]}],"UserModel":{"AppVersion":"","Fk_Country":2,"Fk_Language":2,"Fk_UserState":1,"Fk_UserType":1,"Id":69,"ImageUrl":".","MobileOS":"","MobileVersion":"","Name":"احمد السنوسي","OneSiganlToken":".","Password":".","Phone":"1222272346","Token":"2f451e41-9e94-4b22-a8ee-1d5d1cafb1d2"}}
         */

        let user = User()
        user.id = User(json: Defaults[.user]!)?.id
        user.countryId = userSelectedCountry.id
        user.name = userName
        user.phoneNumber = "+" + userSelectedCountry.code + userPhoneNumber
        user.language = 0
        user.userType = UserType.USER.rawValue
        user.token = User(json: Defaults[.user]!)?.token
        
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
        
        let url = CommonConstants.BASE_URL + "Company/SignUp?token=\(user.token!)"
        
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                MultipartFormData.append(userImage, withName: "ImgFile", fileName: "file1.jpg", mimeType:"image/*")
                MultipartFormData.append(companyImage, withName: "ImgFile2", fileName: "file2.jpg", mimeType:"image/*")
                
                let userJsonObject = try? JSONSerialization.data(withJSONObject: user.toJSON()!, options: JSONSerialization.WritingOptions(rawValue: 0))
                MultipartFormData.append(userJsonObject!, withName: "UserModel")
                
                let companyJsonObject = try? JSONSerialization.data(withJSONObject: company.toJSON()!, options: JSONSerialization.WritingOptions(rawValue: 0))
                MultipartFormData.append(companyJsonObject!, withName: "CompanyModel")
                
                var servicesJsonArray = [Data]()
                
                for service in companyServices {
                    let serviceJsonObject = try? JSONSerialization.data(withJSONObject: service.toJSON()!, options: JSONSerialization.WritingOptions(rawValue: 0))
                    servicesJsonArray.append(serviceJsonObject!)
                    
                }
                
                let jsonArr = try? JSONEncoder().encode(servicesJsonArray)
                MultipartFormData.append(jsonArr!, withName: "OrgTypeModel")
                
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
