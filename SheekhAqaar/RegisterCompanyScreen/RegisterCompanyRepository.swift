//
//  RegisterCompanyRepository.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/26/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Alamofire

public protocol RegisterCompanyPresenterDelegate: class {
    func registerCompanySuccess(company: Company)
    func failed(errorMessage: String)
}

public class RegisterCompanyRepository {
    var delegate: RegisterCompanyPresenterDelegate!
    
    public func setDelegate(delegate: RegisterCompanyPresenterDelegate) {
        self.delegate = delegate
    }
    
    public func registerCompany(userPhoneNumber: String, userName: String, userImage: Data, companyImage: Data, companyServices: [Category], companyName: String, companyTraditionalNumber: String, companyPhoneNumber: String, companyEmail: String, companyCountry: Country, companyRegion: Region, detailedAddress: String, companyLatitude: Double, companyLongitude: Double, userSelectedCountry: Country, companySelectedCountry: Country) {
        
        let user = User()
        user.name = userName
        user.phoneNumber = userPhoneNumber
        user.countryId = userSelectedCountry.id
        user.language = 0
        user.userType = UserType.USER.rawValue
        user.regionId = 0
        
        let company = Company()
        
        var categoriesJsonArray = [Dictionary<String, AnyObject>]()
        for service in companyServices {
            categoriesJsonArray.append(service.toJSON()! as Dictionary<String, AnyObject>)
        }
        
        let params = ["UserModel" : user.toJSON()! as Dictionary<String, AnyObject> , "CompanyModel" : company.toJSON()! as Dictionary<String, AnyObject>, "OrgTypeModel" : categoriesJsonArray] as [String : AnyObject]
        
//        let company1 = Company(id: 1, nameEn: "Company 1", nameAr: "Copany 1", addressEn: "Address 1", addressAr: "Address 1", phoneNumber: "01119993362", latitude: 30.5999552, longitude: 32.2936338, numberOfAds: 10, imageUrl: "https://www.w3schools.com/html/pic_trulli.jpg", colorCode: "#ff00ff", companyServices: companyServices)
        
//        self.delegate.registerCompanySuccess(company: company1)
    }
}
