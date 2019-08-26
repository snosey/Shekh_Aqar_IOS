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
    func getCountriesSuccess(countries: [Country])
    func getServicesSuccess(services: [CompanyService])
    func failed(errorMessage: String)
}

public class RegisterCompanyRepository {
    var delegate: RegisterCompanyPresenterDelegate!
    
    public func setDelegate(delegate: RegisterCompanyPresenterDelegate) {
        self.delegate = delegate
    }
    
    public func registerCompany(userPhoneNumber: String, userName: String, userImage: Data, companyImage: Data, companyServices: [CompanyService], companyName: String, companyTraditionalNumber: String, companyPhoneNumber: String, companyEmail: String, companyCountry: Country, companyRegion: Region, detailedAddress: String, companyLatitude: Double, companyLongitude: Double) {
        
        let company1 = Company(id: 1, nameEn: "Company 1", nameAr: "Copany 1", addressEn: "Address 1", addressAr: "Address 1", phoneNumber: "01119993362", latitude: 30.5999552, longitude: 32.2936338, numberOfAds: 10, imageUrl: "https://www.w3schools.com/html/pic_trulli.jpg", colorCode: "#ff00ff", companyServices: companyServices)
        
        self.delegate.registerCompanySuccess(company: company1)
    }
    
    public func getCountries() {
        let country1 = Country(id: 1, nameEn: "Country 1", nameAr: "الدولة ١", regions: [Region(id: 1, nameEn: "Region 1.1", nameAr: "المنطقة ١.١"), Region(id: 1, nameEn: "Region 1.2", nameAr: "المنطقة ١.٢"), Region(id: 1, nameEn: "Region 1.3", nameAr: "المنطقة ١.٣"), Region(id: 1, nameEn: "Region 1.4", nameAr: "المنطقة ١.٤")])
        
        let country2 = Country(id: 2, nameEn: "Country 2", nameAr: "الدولة ٢", regions: [Region(id: 1, nameEn: "Region 2.1", nameAr: "المنطقة ٢.١"), Region(id: 1, nameEn: "Region 2.2", nameAr: "المنطقة ٢.٢"), Region(id: 1, nameEn: "Region 2.3", nameAr: "المنطقة ٢.٣"), Region(id: 1, nameEn: "Region 2.4", nameAr: "المنطقة ٢.٤")])
        
        let country3 = Country(id: 3, nameEn: "Country 3", nameAr: "الدولة ٣", regions: [Region(id: 1, nameEn: "Region 3.1", nameAr: "المنطقة ٣.١"), Region(id: 1, nameEn: "Region 3.2", nameAr: "المنطقة ٣.٢"), Region(id: 1, nameEn: "Region 3.3", nameAr: "المنطقة ٣.٣"), Region(id: 1, nameEn: "Region 3.4", nameAr: "المنطقة ٣.٤")])
        
        let country4 = Country(id: 4, nameEn: "Country 4", nameAr: "الدولة ٤", regions: [Region(id: 1, nameEn: "Region 4.1", nameAr: "المنطقة ٤.١"), Region(id: 1, nameEn: "Region 4.2", nameAr: "المنطقة ٤.٢"), Region(id: 1, nameEn: "Region 4.3", nameAr: "المنطقة ٤.٣"), Region(id: 1, nameEn: "Region 4.4", nameAr: "المنطق؛ ٤.٤")])
        
        self.delegate.getCountriesSuccess(countries: [country1, country2, country3, country4])
    }
    
    public func getServices() {
        let service1 = CompanyService(id: 1, nameEn: "Service 1", nameAr: "الخدمة ١", key: "ser1")
        let service2 = CompanyService(id: 2, nameEn: "Service 2", nameAr: "الخدمة ١", key: "ser1")
        let service3 = CompanyService(id: 3, nameEn: "Service 3", nameAr: "الخدمة ١", key: "ser1")
        
        self.delegate.getServicesSuccess(services: [service1, service2, service3])
    }
}
