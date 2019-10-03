//
//  EditAdPresenter.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 10/2/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
public protocol EditAdView: class {
    func getCreateAdDataSuccess(createAdData: CreateAdData)
    func editAdSuccess()
    func failed(errorMessage: String)
    func handleNoInternetConnection()
}

public class EditAdPresenter {
    fileprivate weak var editAdView : EditAdView?
    fileprivate let editAdRepository : EditAdRepository?
    
    init(repository: EditAdRepository) {
        self.editAdRepository = repository
        self.editAdRepository?.setDelegate(delegate: self)
    }
    
    // this initialize the presenter view methods
    func setView(view : EditAdView) {
        editAdView = view
    }
}

extension EditAdPresenter {
    
    
    public func getCreateAdData(subCategoryId: Int, latitude: Double, longitude: Double) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            editAdRepository?.getCreateAdData(subCategoryId: subCategoryId, latitude: latitude, longitude: longitude)
        } else {
            editAdView?.handleNoInternetConnection()
        }
    }
    
    public func editAd(ad: Ad, adDetailsItems: [AdDetailsItem], images: [Data], imagesToBeRemoved: [Data]) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            editAdRepository?.editAd(ad: ad, adDetailsItems: adDetailsItems, images: images, imagesToBeRemoved: imagesToBeRemoved)
        } else {
            editAdView?.handleNoInternetConnection()
        }
    }
}

extension EditAdPresenter: EditAdPresenterDelegate {
    public func getCreateAdDataSuccess(createAdData: CreateAdData) {
        UiHelpers.hideLoader()
        editAdView?.getCreateAdDataSuccess(createAdData: createAdData)
    }
    
    public func editAdSuccess() {
        UiHelpers.hideLoader()
        editAdView?.editAdSuccess()
    }
    
    public func failed(errorMessage: String) {
        UiHelpers.hideLoader()
        editAdView?.failed(errorMessage: errorMessage)
    }
}
