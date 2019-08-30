
//
//  AdPresenter.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/30/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation

public protocol FavouritesView: class {
    func getFavouriteAdsSuccess(ads: [Ad])
    func failed(errorMessage: String)
    func handleNoInternetConnection()
}

public class FavouritesPresenter {
    fileprivate weak var favouritesView : FavouritesView?
    fileprivate let favouritesRepository : FavouritesRepository?
    
    init(repository: FavouritesRepository) {
        self.favouritesRepository = repository
        self.favouritesRepository?.setDelegate(delegate: self)
    }
    
    // this initialize the presenter view methods
    func setView(view : FavouritesView) {
        favouritesView = view
    }
}

extension FavouritesPresenter {
    public func getFavouriteAds() {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            favouritesRepository?.getFavouriteAds()
        } else {
            favouritesView?.handleNoInternetConnection()
        }
    }
}

extension FavouritesPresenter: FavouritesPresenterDelegate {
    public func getFavouriteAdsSuccess(ads: [Ad]) {
        UiHelpers.hideLoader()
        favouritesView?.getFavouriteAdsSuccess(ads: ads)
    }
    
    public func failed(errorMessage: String) {
        UiHelpers.hideLoader()
        favouritesView?.failed(errorMessage: errorMessage)
    }
}
