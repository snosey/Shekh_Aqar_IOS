//
//  CompanyRepository.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/27/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Alamofire

public protocol CompanyPresenterDelegate: class {
    func getCompanyAdsSuccess(ads: [Ad])
    func failed(errorMessage: String)
}


public class CompanyRepository {
    var delegate: CompanyPresenterDelegate!
    
    public func setDelegate(delegate: CompanyPresenterDelegate) {
        self.delegate = delegate
    }
    
    public func getCompanyAds(companyId: Int) {
        let category = Category(id: 1, nameEn: "Category 1", nameAr: "مثمن عقاري", key: "cat1", ads: [])
        
//        let ad1 = Ad(id: 1, name: "فيلا للبيع", imagesUrls: ["https://www.w3schools.com/html/pic_trulli.jpg", "https://www.w3schools.com/html/pic_trulli.jpg"], price: "200", currency: Currency(id: 1, nameEn: "R.S", nameAr: "ريال"), details: "Alot of details ", category: category, adType: AdType(id: 1, nameEn: "Type 1", nameAr: "نوع ١"), country: Country(id: 1, nameEn: "asd", nameAr: "asd", regions: []), region: Region(id: 1, nameEn: "asd", nameAr: "asd"), detailedAddress: "alksdjlkj alskdjaksdj laksjd", latitude: 30.1232323, longitude: 31.123123232, farshLevel: FarshLevel(id: 1, nameEn: "alskjd", nameAr: "laksjd"), roomsNumber: 4, bathRoomsNumber: 4, additionalFacilities: [AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd"), AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd"), AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd"), AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd")])
//
//        let ad2 = Ad(id: 1, name: "فيلا للبيع", imagesUrls: ["https://www.w3schools.com/html/pic_trulli.jpg", "https://www.w3schools.com/html/pic_trulli.jpg"], price: "1500", currency: Currency(id: 1, nameEn: "R.S", nameAr: "ريال"), details: "Alot of details ", category: category, adType: AdType(id: 1, nameEn: "Type 1", nameAr: "نوع ١"), country: Country(id: 1, nameEn: "asd", nameAr: "asd", regions: []), region: Region(id: 1, nameEn: "asd", nameAr: "asd"), detailedAddress: "alksdjlkj alskdjaksdj laksjd", latitude: 30.1232323, longitude: 31.123123232, farshLevel: FarshLevel(id: 1, nameEn: "alskjd", nameAr: "laksjd"), roomsNumber: 4, bathRoomsNumber: 4, additionalFacilities: [AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd"), AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd"), AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd"), AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd")])
        
        self.delegate.getCompanyAdsSuccess(ads: [])
        
    }
}
