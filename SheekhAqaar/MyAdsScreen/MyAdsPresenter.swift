
//
//  AdPresenter.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/30/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation

public protocol MyAdsView: class {
    func getMyAdsSuccess(ads: [Ad])
    func failed(errorMessage: String)
    func handleNoInternetConnection()
}

public class MyAdsPresenter {
    fileprivate weak var myAdsView : MyAdsView?
    fileprivate let myAdsRepository : MyAdsRepository?
    
    init(repository: MyAdsRepository) {
        self.myAdsRepository = repository
        self.myAdsRepository?.setDelegate(delegate: self)
    }
    
    // this initialize the presenter view methods
    func setView(view : MyAdsView) {
        myAdsView = view
    }
}

extension MyAdsPresenter {
    public func getMyAds() {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            myAdsRepository?.getMyAds()
        } else {
            myAdsView?.handleNoInternetConnection()
        }
    }
}

extension MyAdsPresenter: MyAdsPresenterDelegate {
    public func getMyAdsSuccess(ads: [Ad]) {
        UiHelpers.hideLoader()
        myAdsView?.getMyAdsSuccess(ads: ads)
    }
    
    public func failed(errorMessage: String) {
        UiHelpers.hideLoader()
        myAdsView?.failed(errorMessage: errorMessage)
    }
}
