//
//  SignUp1Presenter.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/26/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
public protocol SignUp1View : class {
    func registerUserSuccess(user: User)
    func failed(errorMessage: String)
    func handleNoInternetConnection()
}

public class SignUp1Presenter {
    fileprivate weak var signUp1View : SignUp1View?
    fileprivate let signUp1Repository : SignUp1Repository?
    
    init(repository: SignUp1Repository) {
        self.signUp1Repository = repository
        self.signUp1Repository?.setDelegate(delegate: self)
    }
    
    // this initialize the presenter view methods
    func setView(view : SignUp1View) {
        signUp1View = view
    }
}

extension SignUp1Presenter {
    public func registerUser(phoneNumber: String, userName: String, image: Data, countryId: Int) {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            signUp1Repository?.registerUser(phoneNumber: phoneNumber, userName: userName, image: image, countryId: countryId)
        } else {
            signUp1View?.handleNoInternetConnection()
        }
    }
}

extension SignUp1Presenter: SignUp1PresenterDelegate {
    public func registerUserSuccess(user: User) {
        UiHelpers.hideLoader()
        self.signUp1View?.registerUserSuccess(user: user)
    }
    
    public func failed(errorMessage: String) {
        UiHelpers.hideLoader()
        self.signUp1View?.failed(errorMessage: errorMessage)
    }
}
