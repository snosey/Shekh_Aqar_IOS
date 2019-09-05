//
//  HomePresenter.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/26/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation

public protocol HomeView: class {
    func getFirstCategoriesSuccess(categories: [Category])
    func getSecondCategoriesSuccess(categories: [Category])
    func getThirdCategoriesSuccess(categories: [Category])
    func loginSuccess(user: User?, isExist: Bool)
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
    public func getFirstCategories() {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            homeRepository?.getFirstCategories()
        } else {
            homeView?.handleNoInternetConnection()
        }
    }
    
    public func getSecondCategories() {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            homeRepository?.getSecondCategories()
        } else {
            homeView?.handleNoInternetConnection()
        }
    }
    
    public func getThirdCategories() {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            homeRepository?.getThirdCategories()
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
}

extension HomePresenter: HomePresenterDelegate {
    public func getFirstCategoriesSuccess(categories: [Category]) {
        UiHelpers.hideLoader()
        homeView?.getFirstCategoriesSuccess(categories: categories)
    }
    
    public func getSecondCategoriesSuccess(categories: [Category]) {
        UiHelpers.hideLoader()
        homeView?.getSecondCategoriesSuccess(categories: categories)
    }
    
    public func getThirdCategoriesSuccess(categories: [Category]) {
        UiHelpers.hideLoader()
        homeView?.getThirdCategoriesSuccess(categories: categories)
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
