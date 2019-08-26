//
//  SignUp1VC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/18/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class SignUp1VC: BaseVC {

    public class func buildVC(phoneNumber: String) -> SignUp1VC {
        let storyboard = UIStoryboard(name: "SignUp1Storyboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUp1VC") as! SignUp1VC
        vc.phoneNumber = phoneNumber
        return vc
    }
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var changeAvatarImageView: UIImageView!
    @IBOutlet weak var usernameTextfield: LocalizedTextField!
    @IBOutlet weak var backLabel: LocalizedLabel!
    @IBOutlet weak var continueButton: LocalizedButton!
    
    let imagePicker = UIImagePickerController()
    var phoneNumber: String!
    var imageChoosen = false
    var presenter: SignUp1Presenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userAvatarImageView.layer.masksToBounds = true
        userAvatarImageView.layer.cornerRadius = UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 13) / 2
        
        changeAvatarImageView.addTapGesture { [weak self] (_) in
            var alert: UIAlertController!
            
            let photoGalleryAction = UIAlertAction(title: "photoGallery".localized(), style: .default) { (_) in
                self?.openPhotoGallery()
            }
            
            let cameraAction = UIAlertAction(title: "camera".localized(), style: .cancel) { (_) in
                self?.openCamera()
            }
            
            alert = UiHelpers.createAlertView(title: "chooseMediaTitle".localized(), message: "chooseMediaMessage".localized(), actions: [photoGalleryAction, cameraAction])
            
            self?.presentVC(alert)
        }
        
        UiHelpers.makeLabelUnderlined(label: backLabel)
        backLabel.addTapGesture { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        GradientBG.createGradientLayer(view: continueButton, cornerRaduis: 8, maskToBounds: true)
        
        presenter = Injector.provideSignUp1Presenter()
        presenter.setView(view: self)
    }

    @IBAction func continueClicked(_ sender: Any) {
        if let username = usernameTextfield.text, !username.isEmpty {
            if imageChoosen {
                presenter.registerUser(phoneNumber: phoneNumber, userName: username, image: self.userAvatarImageView.image!.jpegData(compressionQuality: 0.5)!)
                
            } else {
                self.view.makeToast("enterAvatar".localized())
            }
        } else {
            self.view.makeToast("enterUsernameField".localized())
        }
    }
    
    private func openPhotoGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension SignUp1VC: SignUp1View {
    func registerUserSuccess(user: User) {
        Defaults[.user] = user.toJSON()
        navigator.navigateToHome()
    }
    
    func failed(errorMessage: String) {
        self.view.makeToast(errorMessage)
    }
    
    func handleNoInternetConnection() {
        self.view.makeToast("noInternetConnection".localized())
    }
}

extension SignUp1VC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true, completion: { [weak self]() -> Void in
            if let chosenImage = info[.originalImage] as? UIImage{
                //use image
                self?.userAvatarImageView.image = chosenImage
                self?.imageChoosen = true
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true)
    }
}
