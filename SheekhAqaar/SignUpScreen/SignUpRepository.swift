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
    func loginSuccess(user: User?, isExist: Bool)
    func getSignUpDataSuccess(signUpData: SignUpData)
    func failed(errorMessage: String)
}

public class SignUpRepository {
    var delegate: SignUpPresenterDelegate!
    
    public func setDelegate(delegate: SignUpPresenterDelegate) {
        self.delegate = delegate
    }
    
    public func login(phoneNumber: String, countryId: Int) {
        let params = ["Phone" : phoneNumber, "Fk_Country" : countryId] as [String : Any]
        let url = CommonConstants.BASE_URL + "User/Login"
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
            
                switch response.result {
                case .success(_):
                    let json = (response.result.value as! Dictionary<String,AnyObject>)
                    if let data = json["Data"] as? Dictionary<String,AnyObject>, let statusJsonObj = json["Status"] as? Dictionary<String,AnyObject> {
                        let user = User(json: data)!
                        let status = Status(json: statusJsonObj)!
                        self.delegate.loginSuccess(user: user, isExist: status.id == 1)
                    }
                break
            
                case .failure(let error):
                    self.delegate.failed(errorMessage: error.localizedDescription)
                break
            }
        }
    }
    
    public func login(token: String) {
        let params = ["token" : token] as [String : Any]
        let url = CommonConstants.BASE_URL + "User/Login"
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                switch response.result {
                case .success(_):
                    let json = (response.result.value as! Dictionary<String,AnyObject>)
                    if let data = json["Data"] as? Dictionary<String,AnyObject>, let statusJsonObj = json["Status"] as? Dictionary<String,AnyObject> {
                        let user = User(json: data)!
                        let status = Status(json: statusJsonObj)!
                        self.delegate.loginSuccess(user: user, isExist: status.id == 1)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate.failed(errorMessage: error.localizedDescription)
                    self.delegate.loginSuccess(user: nil, isExist: false)
                    break
                }
        }
    }
    
    public func getSignUpData() {
        let url = CommonConstants.BASE_URL + "User/SignUp"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                switch response.result {
                case .success(_):
                    let json = (response.result.value as! Dictionary<String,AnyObject>)
                    if let signUpDataDictionary = json["Data"] as? Dictionary<String,AnyObject> {
                        let signUpData = SignUpData(json: signUpDataDictionary)
                        self.delegate.getSignUpDataSuccess(signUpData: signUpData!)
                    }
                    
                    break
                    
                case .failure(let error):
                    self.delegate.failed(errorMessage: error.localizedDescription)
                    break
                }
        }
    }
}
