//
//  HomeRepository.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/26/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyUserDefaults

public protocol HomePresenterDelegate: class {
    func getCategoriesSuccess(firstRowCategories: [Category], secondRowCategories: [Category], thirdRowCategories: [Category])
    func getCompaniesSuccess(companies: [Company])
    func getAdsSuccess(ads: [Ad])
    func loginSuccess(user: User?, isExist: Bool)
    func failed(errorMessage: String)
}


public class HomeRepository {
    var delegate: HomePresenterDelegate!
    
    public func setDelegate(delegate: HomePresenterDelegate) {
        self.delegate = delegate
    }
    
    public func login() {
        let params = ["token" : User(json: Defaults[.user]!)?.token]
        let url = CommonConstants.BASE_URL + "User/Login"
        
        Alamofire.request(url, method: .post, parameters: params as Parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                switch response.result {
                case .success(_):
                    let json = (response.result.value as! Dictionary<String,AnyObject>)
                    if let data = json["Data"] as? Dictionary<String,AnyObject>, let statusJsonObj = json["Status"] as? Dictionary<String,AnyObject> {
                        let user = User(json: data)!
                        let status = Status(json: statusJsonObj)!
                        self.delegate.loginSuccess(user: user, isExist: status.id == 1)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate.failed(errorMessage: error.localizedDescription)
                    break
                }
        }
    }
    
    public func getHomeCategories() {
        
        let url = CommonConstants.BASE_URL + "User/GetHome"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                switch response.result {
                case .success(_):
                    let json = (response.result.value as! Dictionary<String,AnyObject>)
                    let statusObj = json["Status"] as! Dictionary<String,AnyObject>
                    
                    if let id = statusObj["Id"] as? Int, id == 1 {
                        let categoriesJsonObj = json["Data"] as! Dictionary<String,AnyObject>
                        let firstRowJsonArray = categoriesJsonObj["OrgTypeModel"] as! [Dictionary<String,AnyObject>]
                        
                        var firstCategories = [Category]()
                        for firstRowJsonObj in firstRowJsonArray {
                            let category = Category(json: firstRowJsonObj)!
                            firstCategories.append(category)
                        }
                        let addAd = Category()
                        addAd.id = -1
                        addAd.name = "أضف عقار" + "    "
                        
                        let requestAd = Category()
                        requestAd.id = -2
                        requestAd.name = "أطلب عقار" + "    "
                        
                        let registerAsCompany = Category()
                        registerAsCompany.id = -3
                        registerAsCompany.name = "أضف شركتك" + "    "
                        
                        let requestedAds = Category()
                        requestedAds.id = -4
                        requestedAds.name = "العقارات المطلوبة" + "    "
                        
                        firstCategories.append(requestedAds)
                        firstCategories.append(addAd)
                        firstCategories.append(requestAd)
                        firstCategories.append(registerAsCompany)
                        
                        
                        var secondCategories = [Category]()
                        var thirdCategories = [Category]()
                        
                        let secondAndThirdRowJsonArray = categoriesJsonObj["MainCategoryModel"] as! [Dictionary<String,AnyObject>]
                        
                        let mainCategory1 = Category(json: secondAndThirdRowJsonArray[0])!
                        let mainCategory2 = Category(json: secondAndThirdRowJsonArray[1])!
                        
                        let secondRowJsonArray = (secondAndThirdRowJsonArray[0])["SubCategoriesModel"] as! [Dictionary<String,AnyObject>]
                        
                        for secondRowJsonObj in secondRowJsonArray {
                            let category = Category(json: secondRowJsonObj)!
                            secondCategories.append(category)
                        }
                        
                        mainCategory1.subCategories = secondCategories
                        
                        let thirdRowJsonArray = (secondAndThirdRowJsonArray[1])["SubCategoriesModel"] as! [Dictionary<String,AnyObject>]
                        
                        for thirdRowJsonObj in thirdRowJsonArray {
                            let category = Category(json: thirdRowJsonObj)!
                            thirdCategories.append(category)
                        }
                        
                        mainCategory2.subCategories = thirdCategories
                        
                        Singleton.getInstance().mainCategories.append(mainCategory1)
                        Singleton.getInstance().mainCategories.append(mainCategory2)
                        
                        self.delegate.getCategoriesSuccess(firstRowCategories: firstCategories, secondRowCategories: secondCategories, thirdRowCategories: thirdCategories)
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
    
    public func getCompanies(categoryId: Int, latitude: Double, longitude: Double) {
        let params = ["Fk_OrgType" : categoryId, "Latitude" : latitude, "Longitude" : longitude] as [String : Any]
        let url = CommonConstants.BASE_URL + "User/GetCompanies"
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                switch response.result {
                case .success(_):
                    let json = (response.result.value as! Dictionary<String,AnyObject>)
                    let statusObj = json["Status"] as! Dictionary<String,AnyObject>
                    
                    if let id = statusObj["Id"] as? Int, id == 1 {
                        let companiesJsonArray = json["Data"] as! [Dictionary<String,AnyObject>]
                        var companies = [Company]()
                        for companyJsonObj in companiesJsonArray {
                            let company = Company(json: companyJsonObj)
                            companies.append(company!)
                        }
                        self.delegate.getCompaniesSuccess(companies: companies)
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
    
    public func getSignUpData() {
        let url = CommonConstants.BASE_URL + "User/SignUp"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                switch response.result {
                case .success(_):
                    let json = (response.result.value as! Dictionary<String,AnyObject>)
                    if let signUpDataDictionary = json["Data"] as? Dictionary<String,AnyObject> {
                        let signUpData = SignUpData(json: signUpDataDictionary)
                        Singleton.getInstance().signUpData = signUpData
                    }
                    
                    break
                    
                case .failure(let error):
                    self.delegate.failed(errorMessage: error.localizedDescription)
                    break
                }
        }
    }
    
    public func getAds(subCategoryId: Int, latitude: Double, longitude: Double) {
        let params = ["Fk_SubCategory" : subCategoryId, "Latitude" : latitude, "Longitude" : longitude] as [String : Any]
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
                        self.delegate.getAdsSuccess(ads: ads)
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
    
    public func getAds(latitude: Double, longitude: Double) {
        let params = ["Fk_ItemType" : 3, "Latitude" : latitude, "Longitude" : longitude] as [String : Any]
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
                        self.delegate.getAdsSuccess(ads: ads)
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
