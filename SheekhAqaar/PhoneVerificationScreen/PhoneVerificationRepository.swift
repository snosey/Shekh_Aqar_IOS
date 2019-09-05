//
//  PhoneVerificationRepository.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/29/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Alamofire

public protocol PhoneVerificationPresenterDelegate: class {
    func loginSuccess(user: User)
    func failed(errorMessage: String)
}

public class PhoneVerificationRepository {
    var delegate: PhoneVerificationPresenterDelegate!
    
    public func setDelegate(delegate: PhoneVerificationPresenterDelegate) {
        self.delegate = delegate
    }
    
    public func login(phoneNumber: String, password: String) {
//        self.delegate.loginSuccess(user: User(imageUrl: "alksjdlksjdk", name: "Hesham Donia", token: "laksjdaskjd123", phoneNumber: "+201119993362"))
    }
}
