//
//  RegisterCompanyVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/18/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import MICountryPicker
import Localize_Swift
import DropDown

class RegisterCompanyVC: BaseVC {

    public class func buildVC() -> RegisterCompanyVC {
        let storyboard = UIStoryboard(name: "RegisterCompanyStoryboard", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "RegisterCompanyVC") as! RegisterCompanyVC
    }
    
    @IBOutlet weak var companyDataTableView: UITableView!
    
    weak var cell: RegisterCompanyCell!
    weak var weakSelf: RegisterCompanyVC?
    let imagePicker = UIImagePickerController()
    var isUserChangingAvatar: Bool?
    var countries = [Country]()
    var companyServices = [CompanyService]()
    var selectedServices = [CompanyService]()
    var selectedCountry: Country?
    var selectedRegion: Region?
    var userCountryCode = "+966"
    var companyCountryCode = "+966"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weakSelf = self
        companyDataTableView.dataSource = weakSelf
        companyDataTableView.delegate = weakSelf
        
        createFakeCountriesAndRegions()
        createFakeServices()
        
        
    }
    
    func createFakeCountriesAndRegions() {
        let country1 = Country(id: 1, nameEn: "Country 1", nameAr: "الدولة ١", regions: [Region(id: 1, nameEn: "Region 1.1", nameAr: "المنطقة ١.١"), Region(id: 1, nameEn: "Region 1.2", nameAr: "المنطقة ١.٢"), Region(id: 1, nameEn: "Region 1.3", nameAr: "المنطقة ١.٣"), Region(id: 1, nameEn: "Region 1.4", nameAr: "المنطقة ١.٤")])
        
        let country2 = Country(id: 2, nameEn: "Country 2", nameAr: "الدولة ٢", regions: [Region(id: 1, nameEn: "Region 2.1", nameAr: "المنطقة ٢.١"), Region(id: 1, nameEn: "Region 2.2", nameAr: "المنطقة ٢.٢"), Region(id: 1, nameEn: "Region 2.3", nameAr: "المنطقة ٢.٣"), Region(id: 1, nameEn: "Region 2.4", nameAr: "المنطقة ٢.٤")])
        
        let country3 = Country(id: 3, nameEn: "Country 3", nameAr: "الدولة ٣", regions: [Region(id: 1, nameEn: "Region 3.1", nameAr: "المنطقة ٣.١"), Region(id: 1, nameEn: "Region 3.2", nameAr: "المنطقة ٣.٢"), Region(id: 1, nameEn: "Region 3.3", nameAr: "المنطقة ٣.٣"), Region(id: 1, nameEn: "Region 3.4", nameAr: "المنطقة ٣.٤")])
        
        let country4 = Country(id: 4, nameEn: "Country 4", nameAr: "الدولة ٤", regions: [Region(id: 1, nameEn: "Region 4.1", nameAr: "المنطقة ٤.١"), Region(id: 1, nameEn: "Region 4.2", nameAr: "المنطقة ٤.٢"), Region(id: 1, nameEn: "Region 4.3", nameAr: "المنطقة ٤.٣"), Region(id: 1, nameEn: "Region 4.4", nameAr: "المنطق؛ ٤.٤")])
        
        countries.append(country1)
        countries.append(country2)
        countries.append(country3)
        countries.append(country4)
    }
    
    func createFakeServices() {
        let service1 = CompanyService(id: 1, nameEn: "Service 1", nameAr: "الخدمة ١", key: "ser1")
        let service2 = CompanyService(id: 2, nameEn: "Service 2", nameAr: "الخدمة ١", key: "ser1")
        let service3 = CompanyService(id: 3, nameEn: "Service 3", nameAr: "الخدمة ١", key: "ser1")
        
        companyServices.append(service1)
        companyServices.append(service2)
        companyServices.append(service3)
    }

    func showCountriesList(isUser: Bool) {
        
        let picker = MICountryPicker()
        navigationController?.pushViewController(picker, animated: true)
        
        picker.didSelectCountryWithCallingCodeClosure = { name, code, dialCode in
            weak var weakSelf = self
            let bundle = "assets.bundle/"
            if isUser {
                weakSelf?.cell.countryFlagImageView.image = UIImage(named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
                weakSelf?.cell.countryCodeLabel.text = dialCode
                weakSelf?.userCountryCode = dialCode
            } else {
                weakSelf?.cell.companyCountryCodeFlag.image = UIImage(named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
                weakSelf?.cell.companyCountryCodeLabel.text = dialCode
                weakSelf?.companyCountryCode = dialCode
            }
            weakSelf?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func openPhotoGallery(isUserChangingAvatar: Bool) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            weakSelf?.isUserChangingAvatar = isUserChangingAvatar
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func openCamera(isUserChangingAvatar: Bool) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            
            weakSelf?.isUserChangingAvatar = isUserChangingAvatar
            present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension RegisterCompanyVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: RegisterCompanyCell.identifier, for: indexPath) as? RegisterCompanyCell
        
        cell.selectionStyle = .none
        cell.delegate = weakSelf
        cell.services = companyServices
        cell.initializeCell()
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 145)
    }
}

extension RegisterCompanyVC: RegisterCompanyCellDelegate {
    func serviceChecked(checked: Bool, index: Int) {
        if checked {
            weakSelf?.selectedServices.append((weakSelf?.companyServices.get(index))!)
        } else {
            weakSelf?.selectedServices.remove(at: index)
        }        
    }
    
    func changeUserAvatar() {
        var alert: UIAlertController!
        
        let photoGalleryAction = UIAlertAction(title: "photoGallery".localized(), style: .default) { [weak self] (_) in
            self?.openPhotoGallery(isUserChangingAvatar: true)
        }
        
        let cameraAction = UIAlertAction(title: "camera".localized(), style: .cancel) { [weak self] (_) in
            self?.openCamera(isUserChangingAvatar: true)
        }
        
        alert = UiHelpers.createAlertView(title: "chooseMediaTitle".localized(), message: "chooseMediaMessage".localized(), actions: [photoGalleryAction, cameraAction])
        
        weakSelf?.presentVC(alert)
    }
    
    func changeOwnerCountryCode() {
        weakSelf?.showCountriesList(isUser: true)
    }
    
    func changeCompanyAvatar() {
        var alert: UIAlertController!
        
        let photoGalleryAction = UIAlertAction(title: "photoGallery".localized(), style: .default) { [weak self] (_) in
            self?.openPhotoGallery(isUserChangingAvatar: false)
        }
        
        let cameraAction = UIAlertAction(title: "camera".localized(), style: .cancel) { [weak self] (_) in
            self?.openCamera(isUserChangingAvatar: false)
        }
        
        alert = UiHelpers.createAlertView(title: "chooseMediaTitle".localized(), message: "chooseMediaMessage".localized(), actions: [photoGalleryAction, cameraAction])
        
        weakSelf?.presentVC(alert)
    }
    
    func changeCompanyCountryCode() {
         weakSelf?.showCountriesList(isUser: false)
    }
    
    func changeCountry() {
        let dropDown = DropDown()
        dropDown.anchorView = weakSelf?.cell.countryView

        var dataSource = [String]()
        for country in countries {
            if Localize.currentLanguage() == "en" {
                dataSource.append(country.nameEn)
            } else {
                dataSource.append(country.nameAr)
            }
        }

        dropDown.dataSource = dataSource
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self?.cell.countryNameLabel.text = item
            self?.cell.countryNameLabel.textColor = .black
            self?.selectedCountry = self?.countries.get(index)
            
            self?.selectedRegion = nil
            self?.cell.regionNameLabel.text = "region".localized()
            if #available(iOS 13.0, *) {
                self?.cell.regionNameLabel.textColor = .placeholderText
            } else {
                self?.cell.regionNameLabel.textColor = .lightGray
            }
        }
        dropDown.direction = .any
        dropDown.show()
    }
    
    func changeRegion() {
        if let _ = selectedCountry {
            let dropDown = DropDown()
            dropDown.anchorView = weakSelf?.cell.regionView
            var dataSource = [String]()
            for region in selectedCountry?.regions ?? [] {
                if Localize.currentLanguage() == "en" {
                    dataSource.append(region.nameEn)
                } else {
                    dataSource.append(region.nameAr)
                }
            }
            
            dropDown.dataSource = dataSource
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in
                self?.cell.regionNameLabel.text = item
                self?.cell.regionNameLabel.textColor = .black
                self?.selectedRegion = self?.selectedCountry?.regions.get(index)
            }
            dropDown.direction = .any
            dropDown.show()
        } else {
            weakSelf?.view.makeToast("selectCountryFirst".localized())
        }
    }
    
    func registerClicked() {
        if weakSelf?.cell.userImageChoosen ?? false {
            if let fullName = weakSelf?.cell.fullNameTextField.text, !fullName.isEmpty {
                if let userPhoneNumber = weakSelf?.cell.phoneNumberTextField.text, !userPhoneNumber.isEmpty {
                    if userPhoneNumber.isNumber() {
                        if weakSelf?.cell.companyImageChoosen ?? false {
                            if let companyName = weakSelf?.cell.companyNameTextField.text, !companyName.isEmpty {
                                if let companyPhoneNumber = weakSelf?.cell.companyPhoneNumberTextField.text, !companyPhoneNumber.isEmpty {
                                    if companyPhoneNumber.isNumber() {
                                        if let email = weakSelf?.cell.companyEmail.text, !email.isEmpty {
                                            if email.isEmail {
                                                if let _ = weakSelf?.selectedCountry {
                                                    if let _ = weakSelf?.selectedRegion {
                                                        if let detailedAddress = weakSelf?.cell.detailedAddressTextField.text, !detailedAddress.isEmpty {
                                                            if let traditionalNumber = weakSelf?.cell.traditionalNumberTextField.text, !traditionalNumber.isEmpty {
                                                                // go to home
                                                                weakSelf?.navigator.navigateToHome()
                                                            } else {
                                                                weakSelf?.view.makeToast("enterTraditionalnumber".localized())
                                                            }
                                                        } else {
                                                            weakSelf?.view.makeToast("enterDetailedAddress".localized())
                                                        }
                                                    } else {
                                                        weakSelf?.view.makeToast("enterSelectedRegion".localized())
                                                    }
                                                } else {
                                                    weakSelf?.view.makeToast("enterSelectedCountry".localized())
                                                }
                                            } else {
                                                weakSelf?.view.makeToast("enterValidEmail".localized())
                                            }
                                        } else {
                                            weakSelf?.view.makeToast("enterEmail".localized())
                                        }
                                    } else {
                                       weakSelf?.view.makeToast("enterValidPhoneNumber".localized())
                                    }
                                } else {
                                    weakSelf?.view.makeToast("enterCompanyPhoneNumber".localized())
                                }
                            } else {
                                weakSelf?.view.makeToast("enterCompanyName".localized())
                            }
                        } else {
                            weakSelf?.view.makeToast("enterCompanyAvatar".localized())
                        }
                    } else {
                        weakSelf?.view.makeToast("enterValidPhoneNumber".localized())
                    }
                } else {
                    weakSelf?.view.makeToast("enterPhoneField".localized())
                }
            } else {
                weakSelf?.view.makeToast("enterFullName".localized())
            }
        } else {
            weakSelf?.view.makeToast("enterAvatar".localized())
        }
    }
    
    func backClicked() {
        weakSelf?.navigationController?.popViewController(animated: true)
    }
}

extension RegisterCompanyVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true, completion: { [weak self]() -> Void in
            if let chosenImage = info[.originalImage] as? UIImage{
                //use image
                if let isUserChangingAvatar = self?.isUserChangingAvatar {
                    if isUserChangingAvatar {
                        self?.cell.userAvatarImageView.image = chosenImage
                        self?.cell.userImageChoosen = true
                    } else {
                        self?.cell.companyAvatar.image = chosenImage
                        self?.cell.companyImageChoosen = true
                    }
                    self?.isUserChangingAvatar = nil
                }
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true)
    }
}

