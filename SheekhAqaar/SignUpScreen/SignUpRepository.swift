//
//  SignUpRepository.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/26/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Alamofire

public protocol SignUpPresenterDelegate: class {
    func userCheck(isExist: Bool)
    func loginSuccess(user: User)
    func failed(errorMessage: String)
}

public class SignUpRepository {
    var delegate: SignUpPresenterDelegate!
    
    public func setDelegate(delegate: SignUpPresenterDelegate) {
        self.delegate = delegate
    }
    
    public func checkUserExist(phoneNumber: String) {
        self.delegate.userCheck(isExist: true)
    }
    
    public func login(phoneNumber: String) {
        self.delegate.loginSuccess(user: User(imageUrl: "alksjdlksjdk", name: "Hesham Donia", token: "laksjdaskjd123", phoneNumber: "+201119993362"))
    }
}
