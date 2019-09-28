//
//  HomePresenter.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/26/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation

public protocol HomeView: class {
    func getCategoriesSuccess(firstRowCategories: [Category], secondRowCategories: [Category], thirdRowCategories: [Category])
    func loginSuccess(user: User?, isExist: Bool)
    func getCompaniesSuccess(companies: [Company])
    func getAdsSuccess(ads: [Ad])
    func failed(errorMessage: String)
    func handleNoInternetConnection()
}

public class HomePresenter {
    fileprivate weak var homeView : HomeView?
    fileprivate let homeRepository : HomeRepository?
    
    init(repository: HomeRepository) {
        self.homeRepository = repository
        self.homeRepository?.setDelegate(delegate: self)
    }
    
    // this initialize the presenter view methods
    func setView(view : HomeView) {
        homeView = view
    }
}

extension HomePresenter {
    public func getHomeCategories() {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            homeRepository?.getHomeCategories()
        } else {
            homeView?.handleNoInternetConnection()
        }
    }
    
    public func getCompanies(categoryId: Int, latitude: Double, longitude: Double) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            homeRepository?.getCompanies(categoryId: categoryId, latitude: latitude, longitude: longitude)
        } else {
            homeView?.handleNoInternetConnection()
        }
    }
    
    public func getUserData() {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            homeRepository?.login()
        } else {
            homeView?.handleNoInternetConnection()
        }
    }
    
    public func getSignUpData() {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            homeRepository?.getSignUpData()
        } else {
            homeView?.handleNoInternetConnection()
        }
    }
    
    public func getAds(subCategoryId: Int, latitude: Double, longitude: Double) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            homeRepository?.getAds(subCategoryId: subCategoryId, latitude: latitude, longitude: longitude)
        } else {
            homeView?.handleNoInternetConnection()
        }
    }
}

extension HomePresenter: HomePresenterDelegate {
    public func getCompaniesSuccess(companies: [Company]) {
        UiHelpers.hideLoader()
        homeView?.getCompaniesSuccess(companies: companies)
    }
    
    public func getCategoriesSuccess(firstRowCategories: [Category], secondRowCategories: [Category], thirdRowCategories: [Category]) {
        UiHelpers.hideLoader()
        homeView?.getCategoriesSuccess(firstRowCategories: firstRowCategories, secondRowCategories: secondRowCategories, thirdRowCategories: thirdRowCategories)
    }
    
    public func getAdsSuccess(ads: [Ad]) {
         UiHelpers.hideLoader()
        homeView?.getAdsSuccess(ads: ads)
    }
    
    public func loginSuccess(user: User?, isExist: Bool) {
        UiHelpers.hideLoader()
        homeView?.loginSuccess(user: user, isExist: isExist)
    }
    
    public func failed(errorMessage: String) {
        UiHelpers.hideLoader()
        homeView?.failed(errorMessage: errorMessage)
    }
}
