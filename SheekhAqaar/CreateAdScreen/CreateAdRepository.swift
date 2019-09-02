//
//  CreateAdRepository.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/2/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Alamofire

public protocol CreateAdPresenterDelegate: class {
    func getCountriesSuccess(countries: [Country])
    func getCitiesSuccess(cities: [City])
    func getCategoriesSuccess(categories: [Category])
    func getAdTypesSuccess(adTypes: [AdType])
    func getFarshLevelsSuccess(levels: [FarshLevel])
    func getCurrenciesSuccess(currencies: [Currency])
    func getAdditionalFacilitiesSuccess(additionalFacilities: [AdditionalFacility])
    func publishAdSuccess()
    func failed(errorMessage: String)
}

public class CreateAdRepository {
    var delegate: CreateAdPresenterDelegate!
    
    public func setDelegate(delegate: CreateAdPresenterDelegate) {
        self.delegate = delegate
    }
    
    public func getCountries() {
        let country1 = Country(id: 1, nameEn: "Country 1", nameAr: "الدولة ١", regions: [Region(id: 1, nameEn: "Region 1.1", nameAr: "المنطقة ١.١"), Region(id: 1, nameEn: "Region 1.2", nameAr: "المنطقة ١.٢"), Region(id: 1, nameEn: "Region 1.3", nameAr: "المنطقة ١.٣"), Region(id: 1, nameEn: "Region 1.4", nameAr: "المنطقة ١.٤")])
        
        let country2 = Country(id: 2, nameEn: "Country 2", nameAr: "الدولة ٢", regions: [Region(id: 1, nameEn: "Region 2.1", nameAr: "المنطقة ٢.١"), Region(id: 1, nameEn: "Region 2.2", nameAr: "المنطقة ٢.٢"), Region(id: 1, nameEn: "Region 2.3", nameAr: "المنطقة ٢.٣"), Region(id: 1, nameEn: "Region 2.4", nameAr: "المنطقة ٢.٤")])
        
        let country3 = Country(id: 3, nameEn: "Country 3", nameAr: "الدولة ٣", regions: [Region(id: 1, nameEn: "Region 3.1", nameAr: "المنطقة ٣.١"), Region(id: 1, nameEn: "Region 3.2", nameAr: "المنطقة ٣.٢"), Region(id: 1, nameEn: "Region 3.3", nameAr: "المنطقة ٣.٣"), Region(id: 1, nameEn: "Region 3.4", nameAr: "المنطقة ٣.٤")])
        
        let country4 = Country(id: 4, nameEn: "Country 4", nameAr: "الدولة ٤", regions: [Region(id: 1, nameEn: "Region 4.1", nameAr: "المنطقة ٤.١"), Region(id: 1, nameEn: "Region 4.2", nameAr: "المنطقة ٤.٢"), Region(id: 1, nameEn: "Region 4.3", nameAr: "المنطقة ٤.٣"), Region(id: 1, nameEn: "Region 4.4", nameAr: "المنطق؛ ٤.٤")])
        
        self.delegate.getCountriesSuccess(countries: [country1, country2, country3, country4])
    }
    
    public func getCities(countryId: Int) {
        let city1 = City(id: 1, nameEn: "Cairo", nameAr: "القاهرة")
        let city2 = City(id: 2, nameEn: "Ismailia", nameAr: "الاسماعيلية")
        let city3 = City(id: 3, nameEn: "Alexandria", nameAr: "الاسكندرية")
        
        self.delegate.getCitiesSuccess(cities: [city1, city2, city3])
    }
    
    public func getCategories() {
        let category1 = Category(id: 1, nameEn: "Category 1", nameAr: "مثمن عقاري", key: "cat1", ads: [])
        let category2 = Category(id: 2, nameEn: "Category 2", nameAr: "طلبات العقارات", key: "cat1", ads: [])
        let category3 = Category(id: 3, nameEn: "Category 3", nameAr: "شقق للايجار", key: "cat1", ads: [])
        let category4 = Category(id: 4, nameEn: "Category 4", nameAr: "فلل للايجار", key: "cat1", ads: [])
        let category5 = Category(id: 5, nameEn: "Category 5", nameAr: "شقق للبيع", key: "cat1", ads: [])
        
        self.delegate.getCategoriesSuccess(categories: [category1, category2, category3, category4, category5])
    }
    
    
    public func getAdTypes() {
        let adType1 = AdType(id: 1, nameEn: "Type 1", nameAr: "نوع ١")
        let adType2 = AdType(id: 1, nameEn: "Type 1", nameAr: "نوع ١")
        let adType3 = AdType(id: 1, nameEn: "Type 1", nameAr: "نوع ١")
        
        self.delegate.getAdTypesSuccess(adTypes: [adType1, adType2, adType3])
    }
    
    public func getFarshLevels() {
        let level1 = FarshLevel(id: 1, nameEn: "Level 1", nameAr: "المستوي ١")
        let level2 = FarshLevel(id: 2, nameEn: "Level 2", nameAr: "المستوي ٢")
        let level3 = FarshLevel(id: 3, nameEn: "Level 3", nameAr: "المستوي ٣")
        
        self.delegate.getFarshLevelsSuccess(levels: [level1, level2, level3])
    }
    
    public func getCurrencies() {
        let currency1 = Currency(id: 1, nameEn: "R.S", nameAr: "ريال")
        let currency2 = Currency(id: 1, nameEn: "R.S", nameAr: "ريال")
        let currency3 = Currency(id: 1, nameEn: "R.S", nameAr: "ريال")
        
        self.delegate.getCurrenciesSuccess(currencies: [currency1, currency2, currency3])
    }
    
    public func getAdditionalFacilities() {
        let f1 = AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd")
        let f2 = AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd")
        let f3 = AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd")
        let f4 = AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd")
        let f5 = AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd")
        let f6 = AdditionalFacility(id: 1, nameEn: "laksjd", nameAr: "laksjd")
        
        self.delegate.getAdditionalFacilitiesSuccess(additionalFacilities: [f1, f2, f3, f4, f5, f6])
    }
    
    public func publishAd(ad: Ad, images: [Data]) {
        self.delegate.publishAdSuccess()
    }
}
