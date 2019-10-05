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
        let url = CommonConstants.BASE_URL + "User/SignUp"

        let user = User()
        user.countryId = countryId
        user.name = userName
        user.phoneNumber = phoneNumber
        user.language = 0
        user.userType = UserType.USER.rawValue
        
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                 MultipartFormData.append(image, withName: "ImgFile", fileName: "file.jpg", mimeType:"image/*")
                
                let userJsonObject = try? JSONSerialization.data(withJSONObject: user.toJSON()!, options: JSONSerialization.WritingOptions(rawValue: 0))
                MultipartFormData.append(userJsonObject!, withName: "UserModel")
                
        }, to: url) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                print(result)
                upload.responseJSON { response in
                    let json = (response.result.value as! Dictionary<String,AnyObject>)
                    let status = Status(json: json["Status"] as! Dictionary<String, AnyObject>)!
                    if status.id == 1 {
                        if let user = User(json: json["Data"] as! Dictionary<String,AnyObject>) {
                            self.delegate.registerUserSuccess(user: user)
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
