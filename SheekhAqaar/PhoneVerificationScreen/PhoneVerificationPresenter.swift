//
//  PhoneVerificationPresenter.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/29/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
public protocol PhoneVerificationView : class {
    func loginSuccess(user: User)
    func updateProfileSuccess(user: User)
    func failed(errorMessage: String)
    func handleNoInternetConnection()
}

public class PhoneVerificationPresenter {
    fileprivate weak var phoneVerificationView : PhoneVerificationView?
    fileprivate let phoneVerificationRepository : PhoneVerificationRepository?
    
    init(repository: PhoneVerificationRepository) {
        self.phoneVerificationRepository = repository
        self.phoneVerificationRepository?.setDelegate(delegate: self)
    }
    
    // this initialize the presenter view methods
    func setView(view : PhoneVerificationView) {
        phoneVerificationView = view
    }
}

extension PhoneVerificationPresenter {
    public func login(phoneNumber: String, password: String) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            phoneVerificationRepository?.login(phoneNumber: phoneNumber, password: password)
        } else {
            phoneVerificationView?.handleNoInternetConnection()
        }
    }
    
    public func updateProfile(userImageData: Data, username: String, userPhone: String, countryId: Int) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            phoneVerificationRepository?.updateProfile(userImageData: userImageData, username: username, userPhone: userPhone, countryId: countryId)
        } else {
            phoneVerificationView?.handleNoInternetConnection()
        }
    }
}

extension PhoneVerificationPresenter: PhoneVerificationPresenterDelegate {
    public func loginSuccess(user: User) {
        UiHelpers.hideLoader()
        self.phoneVerificationView?.loginSuccess(user: user)
    }
    
    public func updateProfileSuccess(user: User) {
        UiHelpers.hideLoader()
        self.phoneVerificationView?.updateProfileSuccess(user: user)
    }
    
    public func failed(errorMessage: String) {
        UiHelpers.hideLoader()
        self.phoneVerificationView?.failed(errorMessage: errorMessage)
    }
}
