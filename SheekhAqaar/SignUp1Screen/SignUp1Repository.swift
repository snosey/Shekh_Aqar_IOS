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
    
    public func registerUser(phoneNumber: String, userName: String, image: Data, countryId: Int) {
        
        let params = ["Fk_Country" : countryId, "Fk_Language" : 0, "Fk_UserState" : 0, "Fk_UserType" : UserType.USER.rawValue, "Id" : 0, "Name" : userName, "Phone" : phoneNumber] as [String : Any]
        
        let url = CommonConstants.BASE_URL + "User/SignUp"
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                switch response.result {
                case .success(_):
                    let json = (response.result.value as! Dictionary<String,AnyObject>)
                    let entity = Entity<User>(json: json)
                    if entity?.status.id == 1 {
                        if let user = User(json: json["Data"] as! Dictionary<String,AnyObject>) {
                            self.delegate.registerUserSuccess(user: user)
                        } else {
                            self.delegate.failed(errorMessage: "Parsing error in user")
                        }
                    } else {
                        self.delegate.failed(errorMessage: (entity?.status.message)!)
                    }
                    
                    break
                    
                case .failure(let error):
                    self.delegate.failed(errorMessage: error.localizedDescription)
                    break
                }
        }
    }
}
