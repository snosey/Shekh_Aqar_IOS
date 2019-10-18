//
//  EditProfileVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 10/3/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftyUserDefaults

class EditProfileVC: BaseVC {

    public class func buildVC() -> EditProfileVC {
        let storyboard = UIStoryboard(name: "EditProfileStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        return vc
    }
    
    @IBOutlet weak var phoneNumberTextField: LocalizedTextField!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var changeAvatarImageView: UIImageView!
    @IBOutlet weak var usernameTextfield: LocalizedTextField!
    @IBOutlet weak var backLabel: LocalizedLabel!
    @IBOutlet weak var editButton: LocalizedButton!
    
    let imagePicker = UIImagePickerController()
    var phoneNumber: String!
    var code = ""
    var selectedCountry: Country!
    var imageChoosen = false
    let user = User(json: Defaults[.user]!)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryCodeView.addTapGesture { [weak self] (_) in
            self?.showCountriesList()
        }
        
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
        
        GradientBG.createGradientLayer(view: editButton, cornerRaduis: 4, maskToBounds: true)
        
        populateDefaultData()
    }

    @IBAction func editClicked(_ sender: Any) {
        
        if let username = usernameTextfield.text, !username.isEmpty {
           if selectedCountry != nil {
               if let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty {
                   if phoneNumber.isNumber() {
                       self.phoneNumber = phoneNumber
                       let phone = "\(code)\(phoneNumber)"
                        if phoneNumber == user.phoneNumber && user.name == username && !imageChoosen {
                            self.view.makeToast("noDataChanged".localized())
                        } else {
                            PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { [weak self] (verificationID, error) in
                                if let error = error {
                                    print("error :: \(error.localizedDescription)")
                                    return
                                }

                                Defaults[.authVerificationID] = verificationID
                                if let _ = self?.imageChoosen {
                                    self?.navigator.navigateToPhoneVerification(phoneNumber: self?.phoneNumber ?? "", nextPage: CommonConstants.EDIT_PROFILE_CODE, country: self!.selectedCountry, userImage: self?.changeAvatarImageView.image, username: username)
                                } else {
                                    self?.navigator.navigateToPhoneVerification(phoneNumber: self?.phoneNumber ?? "", nextPage: CommonConstants.EDIT_PROFILE_CODE, country: self!.selectedCountry, userImage: nil, username: username)
                                }
                            }
                        }
                   } else {
                       self.view.makeToast("enterValidPhoneNumber".localized())
                   }
               } else {
                   self.view.makeToast("enterPhoneField".localized())
               }
           } else {
               self.view.makeToast("selectCountryError".localized())
           }
        } else {
            self.view.makeToast("enterUsernameField".localized())
        }
    }
    
    func showCountriesList() {
        let vc = CountriesListVC.buildVC(countries: Singleton.getInstance().signUpData.countries)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
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
    
    private func populateDefaultData() {
        
        usernameTextfield.text = user.name
        if let imgUrl = user.imageUrl, let url = URL(string: imgUrl) {
            userAvatarImageView.af_setImage(withURL: url)
        }
        phoneNumberTextField.text = user.phoneNumber
        
        for country in Singleton.getInstance().signUpData.countries {
            if country.id == user.countryId {
                selectedCountry = country
                if let url = URL(string: country.imageUrl) {
                    self.countryFlagImageView.af_setImage(withURL: url)
                }
                self.countryCodeLabel.text = "+" + country.code
                self.code = "+" + country.code
            }
        }
        
    }
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

extension EditProfileVC: CountriesListDelegate {
    func countrySelected(country: Country?) {
        if let country = country {
            if let url = URL(string: country.imageUrl) {
                self.countryFlagImageView.af_setImage(withURL: url)
            }
            self.countryCodeLabel.text = "+" + country.code
            self.code = "+" + country.code
            self.selectedCountry = country
        }
    }
}
