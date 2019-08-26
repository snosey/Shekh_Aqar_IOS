//
//  RegisterCompanyPresenter.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/26/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation

public protocol RegisterCompanyView : class {
    func registerCompanySuccess(company: Company)
    func getCountriesSuccess(countries: [Country])
    func getServicesSuccess(services: [CompanyService])
    func failed(errorMessage: String)
    func handleNoInternetConnection()
}

public class RegisterCompanyPresenter {
    fileprivate weak var registerCompanyView : RegisterCompanyView?
    fileprivate let registerCompanyRepository : RegisterCompanyRepository?
    
    init(repository: RegisterCompanyRepository) {
        self.registerCompanyRepository = repository
        self.registerCompanyRepository?.setDelegate(delegate: self)
    }
    
    // this initialize the presenter view methods
    func setView(view : RegisterCompanyView) {
        registerCompanyView = view
    }
}

extension RegisterCompanyPresenter {
    public func registerCompany(userPhoneNumber: String, userName: String, userImage: Data, companyImage: Data, companyServices: [CompanyService], companyName: String, companyTraditionalNumber: String, companyPhoneNumber: String, companyEmail: String, companyCountry: Country, companyRegion: Region, detailedAddress: String, companyLatitude: Double, companyLongitude: Double) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            registerCompanyRepository?.registerCompany(userPhoneNumber: userPhoneNumber, userName: userName, userImage: userImage, companyImage: companyImage, companyServices: companyServices, companyName: companyName, companyTraditionalNumber: companyTraditionalNumber, companyPhoneNumber: companyPhoneNumber, companyEmail: companyEmail, companyCountry: companyCountry, companyRegion: companyRegion, detailedAddress: detailedAddress, companyLatitude: companyLatitude, companyLongitude: companyLongitude)
        } else {
            registerCompanyView?.handleNoInternetConnection()
        }
    }
    
    public func getCountries() {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            registerCompanyRepository?.getCountries()
        } else {
            registerCompanyView?.handleNoInternetConnection()
        }
    }
    
    public func getServices() {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            registerCompanyRepository?.getServices()
        } else {
            registerCompanyView?.handleNoInternetConnection()
        }
    }
}

extension RegisterCompanyPresenter: RegisterCompanyPresenterDelegate {
    public func registerCompanySuccess(company: Company) {
        UiHelpers.hideLoader()
        self.registerCompanyView?.registerCompanySuccess(company: company)
    }
    
    public func getCountriesSuccess(countries: [Country]) {
        UiHelpers.hideLoader()
        self.registerCompanyView?.getCountriesSuccess(countries: countries)
    }
    
    public func getServicesSuccess(services: [CompanyService]) {
        UiHelpers.hideLoader()
        self.registerCompanyView?.getServicesSuccess(services: services)
    }
    
    public func failed(errorMessage: String) {
        UiHelpers.hideLoader()
        self.registerCompanyView?.failed(errorMessage: errorMessage)
    }
}
