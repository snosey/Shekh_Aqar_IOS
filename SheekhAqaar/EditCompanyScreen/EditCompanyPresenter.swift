//
//  EditCompanyPresenter.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 10/5/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
public protocol EditCompanyView: class {
    func getCompanySuccess(company: Company)
    func editCompanySuccess(user: User)
    func failed(errorMessage: String)
    func handleNoInternetConnection()
}

public class EditCompanyPresenter {
    fileprivate weak var editCompanyView : EditCompanyView?
    fileprivate let editCompanyRepository : EditCompanyRepository?
    
    init(repository: EditCompanyRepository) {
        self.editCompanyRepository = repository
        self.editCompanyRepository?.setDelegate(delegate: self)
    }
    
    // this initialize the presenter view methods
    func setView(view : EditCompanyView) {
        editCompanyView = view
    }
}

extension EditCompanyPresenter {
    
    public func getCompany(companyId: Int) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            editCompanyRepository?.getCompany(companyId: companyId)
        } else {
            editCompanyView?.handleNoInternetConnection()
        }
    }
    
    public func editCompany(userPhoneNumber: String, userName: String, userImage: Data, companyImage: Data, companyServices: [Category], companyName: String, companyTraditionalNumber: String, companyPhoneNumber: String, companyEmail: String, companyCountry: Country, companyRegion: Region, detailedAddress: String, companyLatitude: Double, companyLongitude: Double, userSelectedCountry: Country, companySelectedCountry: Country) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            editCompanyRepository?.editCompany(userPhoneNumber: userPhoneNumber, userName: userName, userImage: userImage, companyImage: companyImage, companyServices: companyServices, companyName: companyName, companyTraditionalNumber: companyTraditionalNumber, companyPhoneNumber: companyPhoneNumber, companyEmail: companyEmail, companyCountry: companyCountry, companyRegion: companyRegion, detailedAddress: detailedAddress, companyLatitude: companyLatitude, companyLongitude: companyLongitude, userSelectedCountry: userSelectedCountry, companySelectedCountry: companySelectedCountry)
        } else {
            editCompanyView?.handleNoInternetConnection()
        }
    }
}

extension EditCompanyPresenter: EditCompanyPresenterDelegate {
    public func editCompanySuccess(user: User) {
        UiHelpers.hideLoader()
        editCompanyView?.editCompanySuccess(user: user)
    }
    
    
    public func getCompanySuccess(company: Company) {
        UiHelpers.hideLoader()
        editCompanyView?.getCompanySuccess(company: company)
    }
    
    public func failed(errorMessage: String) {
        UiHelpers.hideLoader()
        editCompanyView?.failed(errorMessage: errorMessage)
    }
}
