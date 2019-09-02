//
//  CreateAdPresenter.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/2/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
public protocol CreateAdView: class {
    func getCountriesSuccess(countries: [Country])
    func getCitiesSuccess(cities: [City])
    func getCategoriesSuccess(categories: [Category])
    func getAdTypesSuccess(adTypes: [AdType])
    func getFarshLevelsSuccess(levels: [FarshLevel])
    func getCurrenciesSuccess(currencies: [Currency])
    func getAdditionalFacilitiesSuccess(additionalFacilities: [AdditionalFacility])
    func publishAdSuccess()
    func failed(errorMessage: String)
    func handleNoInternetConnection()
}

public class CreateAdPresenter {
    fileprivate weak var createAdView : CreateAdView?
    fileprivate let createAdRepository : CreateAdRepository?
    
    init(repository: CreateAdRepository) {
        self.createAdRepository = repository
        self.createAdRepository?.setDelegate(delegate: self)
    }
    
    // this initialize the presenter view methods
    func setView(view : CreateAdView) {
        createAdView = view
    }
}

extension CreateAdPresenter {
    public func getCountries() {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            createAdRepository?.getCountries()
        } else {
            createAdView?.handleNoInternetConnection()
        }
    }
    
    public func getCities(countryId: Int) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            createAdRepository?.getCities(countryId: countryId)
        } else {
            createAdView?.handleNoInternetConnection()
        }
    }
    
    public func getCategories() {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            createAdRepository?.getCategories()
        } else {
            createAdView?.handleNoInternetConnection()
        }
    }
    
    public func getAdTypes() {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            createAdRepository?.getAdTypes()
        } else {
            createAdView?.handleNoInternetConnection()
        }
    }
    
    public func getFarshLevels() {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            createAdRepository?.getFarshLevels()
        } else {
            createAdView?.handleNoInternetConnection()
        }
    }
    
    public func getCurrencies() {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            createAdRepository?.getCurrencies()
        } else {
            createAdView?.handleNoInternetConnection()
        }
    }
    
    public func getAdditionalFacilities() {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            createAdRepository?.getAdditionalFacilities()
        } else {
            createAdView?.handleNoInternetConnection()
        }
    }
    
    public func publishAd(ad: Ad, images: [Data]) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            createAdRepository?.publishAd(ad: ad, images: images)
        } else {
            createAdView?.handleNoInternetConnection()
        }
    }
}

extension CreateAdPresenter: CreateAdPresenterDelegate {
    public func publishAdSuccess() {
        UiHelpers.hideLoader()
        createAdView?.publishAdSuccess()
    }
    
    public func getCountriesSuccess(countries: [Country]) {
        UiHelpers.hideLoader()
        createAdView?.getCountriesSuccess(countries: countries)
    }
    
    public func getCitiesSuccess(cities: [City]) {
        UiHelpers.hideLoader()
        createAdView?.getCitiesSuccess(cities: cities)
    }
    
    public func getCategoriesSuccess(categories: [Category]) {
        UiHelpers.hideLoader()
        createAdView?.getCategoriesSuccess(categories: categories)
    }
    
    public func getAdTypesSuccess(adTypes: [AdType]) {
        UiHelpers.hideLoader()
        createAdView?.getAdTypesSuccess(adTypes: adTypes)
    }
    
    public func getFarshLevelsSuccess(levels: [FarshLevel]) {
        UiHelpers.hideLoader()
        createAdView?.getFarshLevelsSuccess(levels: levels)
    }
    
    public func getCurrenciesSuccess(currencies: [Currency]) {
        UiHelpers.hideLoader()
        createAdView?.getCurrenciesSuccess(currencies: currencies)
    }
    
    public func getAdditionalFacilitiesSuccess(additionalFacilities: [AdditionalFacility]) {
        UiHelpers.hideLoader()
        createAdView?.getAdditionalFacilitiesSuccess(additionalFacilities: additionalFacilities)
    }
    
    public func failed(errorMessage: String) {
        UiHelpers.hideLoader()
        createAdView?.failed(errorMessage: errorMessage)
    }
}
