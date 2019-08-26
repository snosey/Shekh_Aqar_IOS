//
//  HomeRepository.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/26/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Alamofire

public protocol HomePresenterDelegate: class {
    func getFirstCategoriesSuccess(categories: [Category])
    func getSecondCategoriesSuccess(categories: [Category])
    func getThirdCategoriesSuccess(categories: [Category])
    func failed(errorMessage: String)
}


public class HomeRepository {
    var delegate: HomePresenterDelegate!
    
    public func setDelegate(delegate: HomePresenterDelegate) {
        self.delegate = delegate
    }
    
    public func getFirstCategories() {
        
        let service1 = CompanyService(id: 1, nameEn: "Service 1", nameAr: "الخدمة ١", key: "ser1")
        let service2 = CompanyService(id: 2, nameEn: "Service 2", nameAr: "الخدمة ١", key: "ser1")
        let service3 = CompanyService(id: 3, nameEn: "Service 3", nameAr: "الخدمة ١", key: "ser1")
        
        let company1 = Company(id: 1, nameEn: "Company 1", nameAr: "Copany 1", addressEn: "Address 1", addressAr: "Address 1", phoneNumber: "01119993362", latitude: 30.5999552, longitude: 32.2936338, numberOfAds: 10, imageUrl: "https://www.w3schools.com/html/pic_trulli.jpg", colorCode: "#ff00ff", companyServices: [service1, service2, service3])
        
        let company2 = Company(id: 1, nameEn: "Company 1", nameAr: "Copany 1", addressEn: "Address 1", addressAr: "Address 1", phoneNumber: "01119993362", latitude: 30.5999552, longitude: 32.2936338, numberOfAds: 10, imageUrl: "https://www.w3schools.com/html/pic_trulli.jpg", colorCode: "#ff00ff", companyServices: [service1, service2, service3])
        
        let company3 = Company(id: 1, nameEn: "Company 1", nameAr: "Copany 1", addressEn: "Address 1", addressAr: "Address 1", phoneNumber: "01119993362", latitude: 30.5999552, longitude: 32.2936338, numberOfAds: 10, imageUrl: "https://www.w3schools.com/html/pic_trulli.jpg", colorCode: "#ff00ff", companyServices: [service1, service2, service3])
        
        let category1 = Category(id: 1, nameEn: "Category 1", nameAr: "مثمن عقاري", key: "cat1", companies: [company1, company2, company3])
        let category2 = Category(id: 2, nameEn: "Category 2", nameAr: "طلبات العقارات", key: "cat1", companies: [company1, company2, company3])
        let category3 = Category(id: 3, nameEn: "Category 3", nameAr: "شقق للايجار", key: "cat1", companies: [company1, company2, company3])
        let category4 = Category(id: 4, nameEn: "Category 4", nameAr: "فلل للايجار", key: "cat1", companies: [company1, company2, company3])
        let category5 = Category(id: 5, nameEn: "Category 5", nameAr: "شقق للبيع", key: "cat1", companies: [company1, company2, company3])
        
        self.delegate.getFirstCategoriesSuccess(categories: [category1, category2, category3, category4, category5])
        
    }
    
    public func getSecondCategories() {
        
         let category = Category(id: 1, nameEn: "Category 1", nameAr: "مثمن عقاري", key: "cat1", ads: [])
        
        let ad1 = Ad(id: 1, name: "فيلا للبيع", imagesUrls: ["https://www.w3schools.com/html/pic_trulli.jpg", "https://www.w3schools.com/html/pic_trulli.jpg"], price: "2000", currency: Currency(id: 1, nameEn: "R.S", nameAr: "ريال"), details: "Alot of details ", category: category, adType: AdType(id: 1, nameEn: "Type 1", nameAr: "نوع ١"), country: Country(id: 1, nameEn: "asd", nameAr: "asd", regions: []), region: Region(id: 1, nameEn: "asd", nameAr: "asd"), detailedAddress: "alksdjlkj alskdjaksdj laksjd", latitude: 30.1232323, longitude: 31.123123232, farshLevel: FarshLevel(id: 1, nameEn: "alskjd", nameAr: "laksjd"), roomsNumber: 4, bathRoomsNumber: 4, additionalFacilities: [AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd"), AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd"), AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd"), AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd")])
        
        let ad2 = Ad(id: 1, name: "فيلا للبيع", imagesUrls: ["https://www.w3schools.com/html/pic_trulli.jpg", "https://www.w3schools.com/html/pic_trulli.jpg"], price: "2000", currency: Currency(id: 1, nameEn: "R.S", nameAr: "ريال"), details: "Alot of details ", category: category, adType: AdType(id: 1, nameEn: "Type 1", nameAr: "نوع ١"), country: Country(id: 1, nameEn: "asd", nameAr: "asd", regions: []), region: Region(id: 1, nameEn: "asd", nameAr: "asd"), detailedAddress: "alksdjlkj alskdjaksdj laksjd", latitude: 30.1232323, longitude: 31.123123232, farshLevel: FarshLevel(id: 1, nameEn: "alskjd", nameAr: "laksjd"), roomsNumber: 4, bathRoomsNumber: 4, additionalFacilities: [AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd"), AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd"), AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd"), AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd")])
        
        let category1 = Category(id: 1, nameEn: "Category 1", nameAr: "مثمن عقاري", key: "cat1", ads: [ad1, ad2])
        let category2 = Category(id: 2, nameEn: "Category 2", nameAr: "طلبات العقارات", key: "cat1", ads: [ad1, ad2])
        let category3 = Category(id: 3, nameEn: "Category 3", nameAr: "شقق للايجار", key: "cat1", ads: [ad1, ad2])
        let category4 = Category(id: 4, nameEn: "Category 4", nameAr: "فلل للايجار", key: "cat1", ads: [ad1, ad2])
        let category5 = Category(id: 5, nameEn: "Category 5", nameAr: "شقق للبيع", key: "cat1", ads: [ad1, ad2])
        
        self.delegate.getSecondCategoriesSuccess(categories: [category1, category2, category3, category4, category5])
    }
    
    public func getThirdCategories() {
        let category = Category(id: 1, nameEn: "Category 1", nameAr: "مثمن عقاري", key: "cat1", ads: [])
        
        let ad1 = Ad(id: 1, name: "فيلا للبيع", imagesUrls: ["https://www.w3schools.com/html/pic_trulli.jpg", "https://www.w3schools.com/html/pic_trulli.jpg"], price: "2000", currency: Currency(id: 1, nameEn: "R.S", nameAr: "ريال"), details: "Alot of details ", category: category, adType: AdType(id: 1, nameEn: "Type 1", nameAr: "نوع ١"), country: Country(id: 1, nameEn: "asd", nameAr: "asd", regions: []), region: Region(id: 1, nameEn: "asd", nameAr: "asd"), detailedAddress: "alksdjlkj alskdjaksdj laksjd", latitude: 30.1232323, longitude: 31.123123232, farshLevel: FarshLevel(id: 1, nameEn: "alskjd", nameAr: "laksjd"), roomsNumber: 4, bathRoomsNumber: 4, additionalFacilities: [AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd"), AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd"), AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd"), AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd")])
        
        let ad2 = Ad(id: 1, name: "فيلا للبيع", imagesUrls: ["https://www.w3schools.com/html/pic_trulli.jpg", "https://www.w3schools.com/html/pic_trulli.jpg"], price: "2000", currency: Currency(id: 1, nameEn: "R.S", nameAr: "ريال"), details: "Alot of details ", category: category, adType: AdType(id: 1, nameEn: "Type 1", nameAr: "نوع ١"), country: Country(id: 1, nameEn: "asd", nameAr: "asd", regions: []), region: Region(id: 1, nameEn: "asd", nameAr: "asd"), detailedAddress: "alksdjlkj alskdjaksdj laksjd", latitude: 30.1232323, longitude: 31.123123232, farshLevel: FarshLevel(id: 1, nameEn: "alskjd", nameAr: "laksjd"), roomsNumber: 4, bathRoomsNumber: 4, additionalFacilities: [AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd"), AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd"), AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd"), AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd")])
        
        let category1 = Category(id: 1, nameEn: "Category 1", nameAr: "مثمن عقاري", key: "cat1", ads: [ad1, ad2])
        let category2 = Category(id: 2, nameEn: "Category 2", nameAr: "طلبات العقارات", key: "cat1", ads: [ad1, ad2])
        let category3 = Category(id: 3, nameEn: "Category 3", nameAr: "شقق للايجار", key: "cat1", ads: [ad1, ad2])
        let category4 = Category(id: 4, nameEn: "Category 4", nameAr: "فلل للايجار", key: "cat1", ads: [ad1, ad2])
        let category5 = Category(id: 5, nameEn: "Category 5", nameAr: "شقق للبيع", key: "cat1", ads: [ad1, ad2])
        
        self.delegate.getThirdCategoriesSuccess(categories: [category1, category2, category3, category4, category5])
    }
}
