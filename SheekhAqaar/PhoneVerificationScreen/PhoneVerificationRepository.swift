//
//  PhoneVerificationRepository.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/29/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyUserDefaults

public protocol PhoneVerificationPresenterDelegate: class {
    func loginSuccess(user: User)
    func updateProfileSuccess(user: User)
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
    
    public func updateProfile(userImageData: Data, username: String, userPhone: String, countryId: Int) {
        var url = CommonConstants.BASE_URL + "User/SignUp"
        
        let user = User()
        user.countryId = countryId
        user.name = username
        user.phoneNumber = userPhone
        user.language = 0
        user.userType = UserType.USER.rawValue
        
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                MultipartFormData.append(userImageData, withName: "ImgFile", fileName: "file.jpg", mimeType:"image/*")
                
                let userJsonObject = try? JSONSerialization.data(withJSONObject: user.toJSON()!, options: JSONSerialization.WritingOptions(rawValue: 0))
                MultipartFormData.append(userJsonObject!, withName: "UserModel")
                
                guard let token = User(json: Defaults[.user]!)?.token else {
                    return
                }
                url = url + "?token=\(token)"
                
        }, to: url) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                print(result)
                upload.responseJSON { response in
                    let json = (response.result.value as! Dictionary<String,AnyObject>)
                    let status = Status(json: json["Status"] as! Dictionary<String, AnyObject>)!
                    if status.id == 1 {
                        if let user = User(json: json["Data"] as! Dictionary<String,AnyObject>) {
                            self.delegate.updateProfileSuccess(user: user)
                        } else {
                            self.delegate.failed(errorMessage: "Parsing error in user")
                        }
                    } else {
                        self.delegate.failed(errorMessage: (status.message)!)
                    }
                }
                break
                
            case .failure(let error):
                self.delegate.failed(errorMessage: error.localizedDescription)
                break
            }
            
        }
    }
}
