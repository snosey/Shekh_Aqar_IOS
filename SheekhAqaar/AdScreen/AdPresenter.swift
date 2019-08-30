//
//  AdPresenter.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/30/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
public protocol AdView: class {
    func saveFavouriteAdSuccess()
    func removeFavouriteAdSuccess()
    func failed(errorMessage: String)
    func handleNoInternetConnection()
}

public class AdPresenter {
    fileprivate weak var adView : AdView?
    fileprivate let adRepository : AdRepository?
    
    init(repository: AdRepository) {
        self.adRepository = repository
        self.adRepository?.setDelegate(delegate: self)
    }
    
    // this initialize the presenter view methods
    func setView(view : AdView) {
        adView = view
    }
}

extension AdPresenter {
    public func saveFavouriteAd(ad: Ad) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            adRepository?.saveFavouriteAd(ad: ad)
        } else {
            adView?.handleNoInternetConnection()
        }
    }
    
    public func removeFavouriteAd(ad: Ad) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            adRepository?.removeFavouriteAd(ad: ad)
        } else {
            adView?.handleNoInternetConnection()
        }
    }
}

extension AdPresenter: AdPresenterDelegate {
    public func saveFavouriteAdSuccess() {
        UiHelpers.hideLoader()
        adView?.saveFavouriteAdSuccess()
    }
    
    public func removeFavouriteAdSuccess() {
        UiHelpers.hideLoader()
        adView?.removeFavouriteAdSuccess()
    }
    
    public func failed(errorMessage: String) {
        UiHelpers.hideLoader()
        adView?.failed(errorMessage: errorMessage)
    }
}
