//
//  CompanyPresenter.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/27/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation

public protocol CompanyView: class {
    func getCompanyAdsSuccess(ads: [Ad])
    func failed(errorMessage: String)
    func handleNoInternetConnection()
}

public class CompanyPresenter {
    fileprivate weak var companyView : CompanyView?
    fileprivate let companyRepository : CompanyRepository?
    
    init(repository: CompanyRepository) {
        self.companyRepository = repository
        self.companyRepository?.setDelegate(delegate: self)
    }
    
    // this initialize the presenter view methods
    func setView(view : CompanyView) {
        companyView = view
    }
}

extension CompanyPresenter {
    public func getCompanyAds(companyId: Int) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            companyRepository?.getCompanyAds(companyId: companyId)
        } else {
            companyView?.handleNoInternetConnection()
        }
    }
}

extension CompanyPresenter: CompanyPresenterDelegate {
    public func getCompanyAdsSuccess(ads: [Ad]) {
        UiHelpers.hideLoader()
        companyView?.getCompanyAdsSuccess(ads: ads)
    }
    
    public func failed(errorMessage: String) {
        UiHelpers.hideLoader()
        companyView?.failed(errorMessage: errorMessage)
    }
}
