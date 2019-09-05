//
//  SignUp1Repository.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/26/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Alamofire

public protocol SignUp1PresenterDelegate: class {
    func registerUserSuccess(user: User)
    func failed(errorMessage: String)
}

public class SignUp1Repository {
    var delegate: SignUp1PresenterDelegate!
    
    public func setDelegate(delegate: SignUp1PresenterDelegate) {
        self.delegate = delegate
    }
    
    public func registerUser(phoneNumber: String, userName: String, image: Data) {
//        self.delegate.registerUserSuccess(user: User(imageUrl: "alksjdlksjdk", name: "Hesham Donia", token: "laksjdaskjd123", phoneNumber: "+201119993362"))
    }
}
