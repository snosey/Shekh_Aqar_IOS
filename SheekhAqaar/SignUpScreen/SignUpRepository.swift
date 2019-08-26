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
}
