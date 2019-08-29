//
//  SignUpPresenter.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/26/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation

public protocol SignUpView : class {
    func failed(errorMessage: String)
    func userCheck(isExist: Bool)
    func loginSuccess(user: User)
    func handleNoInternetConnection()
}

public class SignUpPresenter {
    fileprivate weak var signUpView : SignUpView?
    fileprivate let signUpRepository : SignUpRepository?
    
    init(repository: SignUpRepository) {
        self.signUpRepository = repository
        self.signUpRepository?.setDelegate(delegate: self)
    }
    
    // this initialize the presenter view methods
    func setView(view : SignUpView) {
        signUpView = view
    }
}

extension SignUpPresenter {
    public func checkUserExist(phoneNumber: String) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            signUpRepository?.checkUserExist(phoneNumber: phoneNumber)
        } else {
            signUpView?.handleNoInternetConnection()
        }
    }
    
    public func login(phoneNumber: String) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            signUpRepository?.login(phoneNumber: phoneNumber)
        } else {
            signUpView?.handleNoInternetConnection()
        }
    }
}

extension SignUpPresenter: SignUpPresenterDelegate {
    public func userCheck(isExist: Bool) {
        UiHelpers.hideLoader()
        self.signUpView?.userCheck(isExist: isExist)
    }
    
    public func loginSuccess(user: User) {
        UiHelpers.hideLoader()
        self.signUpView?.loginSuccess(user: user)
    }
    
    public func failed(errorMessage: String) {
        UiHelpers.hideLoader()
        self.signUpView?.failed(errorMessage: errorMessage)
    }
}
