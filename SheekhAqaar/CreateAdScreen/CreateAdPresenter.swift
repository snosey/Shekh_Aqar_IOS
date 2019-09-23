//
//  CreateAdPresenter.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/2/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
public protocol CreateAdView: class {
    func getCreateAdDataSuccess(createAdData: CreateAdData)
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
    
    
    public func getCreateAdData(subCategoryId: Int, latitude: Double, longitude: Double) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            createAdRepository?.getCreateAdData(subCategoryId: subCategoryId, latitude: latitude, longitude: longitude)
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
    public func getCreateAdDataSuccess(createAdData: CreateAdData) {
        UiHelpers.hideLoader()
        createAdView?.getCreateAdDataSuccess(createAdData: createAdData)
    }
    
    public func publishAdSuccess() {
        UiHelpers.hideLoader()
        createAdView?.publishAdSuccess()
    }
    
    public func failed(errorMessage: String) {
        UiHelpers.hideLoader()
        createAdView?.failed(errorMessage: errorMessage)
    }
}
