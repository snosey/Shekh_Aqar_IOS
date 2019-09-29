//
//  RequestBuildingPresenter.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/29/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
//
//  CreateAdPresenter.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/2/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
public protocol RequestBuildingView: class {
    func getRequestBuildingDataSuccess(createAdData: CreateAdData)
    func requestBuildingSuccess()
    func failed(errorMessage: String)
    func handleNoInternetConnection()
}

public class RequestBuildingPresenter {
    fileprivate weak var requestBuildingView : RequestBuildingView?
    fileprivate let requestBuildingRepository : RequestBuildingRepository?
    
    init(repository: RequestBuildingRepository) {
        self.requestBuildingRepository = repository
        self.requestBuildingRepository?.setDelegate(delegate: self)
    }
    
    // this initialize the presenter view methods
    func setView(view : RequestBuildingView) {
        requestBuildingView = view
    }
}

extension RequestBuildingPresenter {
    
    
    public func getRequestBuildingData(subCategoryId: Int, latitude: Double, longitude: Double) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            requestBuildingRepository?.getRequestBuildingData(subCategoryId: subCategoryId, latitude: latitude, longitude: longitude)
        } else {
            requestBuildingView?.handleNoInternetConnection()
        }
    }
    
    public func requestBuilding(adTitle: String, additionalFacilities: [String], adDetailsItems: [String]) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            requestBuildingRepository?.requestBuilding(adTitle: adTitle, additionalFacilities: additionalFacilities, adDetailsItems: adDetailsItems)
        } else {
            requestBuildingView?.handleNoInternetConnection()
        }
    }
}

extension RequestBuildingPresenter: RequestBuildingPresenterDelegate {
    public func getRequestBuildingDataSuccess(createAdData: CreateAdData) {
        UiHelpers.hideLoader()
        requestBuildingView?.getRequestBuildingDataSuccess(createAdData: createAdData)
    }
    
    public func requestBuildingSuccess() {
        UiHelpers.hideLoader()
        requestBuildingView?.requestBuildingSuccess()
    }
    
    public func failed(errorMessage: String) {
        UiHelpers.hideLoader()
        requestBuildingView?.failed(errorMessage: errorMessage)
    }
}
