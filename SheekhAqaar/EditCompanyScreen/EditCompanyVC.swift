//
//  EditCompanyVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 10/5/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import Localize_Swift
import DropDown
import GoogleMaps
import GooglePlacePicker
import SwiftyUserDefaults

class EditCompanyVC: BaseVC {
    
    public class func buildVC() -> EditCompanyVC {
        let storyboard = UIStoryboard(name: "EditCompanyStoryboard", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "EditCompanyVC") as! EditCompanyVC
    }
    
    @IBOutlet weak var companyDataTableView: UITableView!

    weak var cell: RegisterCompanyCell!
    let imagePicker = UIImagePickerController()
    var isUserChangingAvatar: Bool?
    var countries = Singleton.getInstance().signUpData.countries
    var selectedServices = [Category]()
    var selectedCountry = Singleton.getInstance().signUpData.countries.get(0)
    var userSelectedCountry = Singleton.getInstance().signUpData.countries.get(0)
    var companySelectedCountry = Singleton.getInstance().signUpData.countries.get(0)
    var selectedRegion: Region?
    var userCountryCode = "+" + (Singleton.getInstance().signUpData.countries.get(0)?.code ?? "966")
    var companyCountryCode = "+" + (Singleton.getInstance().signUpData.countries.get(0)?.code ?? "966")
    var locationManager = CLLocationManager()
    var alertController: UIAlertController!
    var presenter: EditCompanyPresenter!
    var isUser: Bool!
    var selectedLatitude: Double!
    var selectedLongitude: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = Injector.provideEditCompanyPresenter()
        presenter.setView(view: self)
        let company = Company(json: Defaults[.company]!)!
        presenter.getCompany(companyId: company.id)
        
        companyDataTableView.dataSource = self
        companyDataTableView.delegate = self
        companyDataTableView.reloadData()
    }
    
    func showCountriesList(isUser: Bool) {
        
        let vc = CountriesListVC.buildVC(countries: Singleton.getInstance().signUpData.countries)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        self.isUser = isUser
    }
    
    private func openPhotoGallery(isUserChangingAvatar: Bool) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            self.isUserChangingAvatar = isUserChangingAvatar
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func openCamera(isUserChangingAvatar: Bool) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            
            self.isUserChangingAvatar = isUserChangingAvatar
            present(imagePicker, animated: true, completion: nil)
        }
    }

}

extension EditCompanyVC: EditCompanyView {
    func editCompanySuccess(user: User) {
        
        Defaults[.user] = user.toJSON()
        if let companies = user.companies, companies.count > 0 {
            let company = companies[0]
            Defaults[.company] = company.toJSON()
        }
        
        self.view.makeToast("editCompanySuccess".localized(), duration: 2) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getCompanySuccess(company: Company) {
        
        selectedLatitude = Double(company.latitude)!
        selectedLongitude = Double(company.longitude)!
        
        for region in companySelectedCountry!.regions {
            if region.id == company.regionId {
                selectedRegion = region
            }
        }
        
        cell.showCompanyData(company: company)
    }
    
    func failed(errorMessage: String) {
        self.view.makeToast(errorMessage)
    }
    
    func handleNoInternetConnection() {
        self.view.makeToast("noInternetConnection".localized())
    }
}

extension EditCompanyVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: RegisterCompanyCell.identifier, for: indexPath) as? RegisterCompanyCell
        
        cell.selectionStyle = .none
        cell.delegate = self
        cell.categories = Singleton.getInstance().signUpData.categories
        cell.userSelectedCountry = userSelectedCountry
        cell.companySelectedCountry = companySelectedCountry
        cell.initializeCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let _ = Defaults[.user] {
            return UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 123)
        }
        return UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 145)
    }
}

extension EditCompanyVC: GMSPlacePickerViewControllerDelegate {
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        viewController.dismiss(animated: true, completion: nil)
        
        cell.addressOnMapLabel.text = place.formattedAddress
        self.selectedLatitude = place.coordinate.latitude
        self.selectedLongitude = place.coordinate.longitude
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
}

extension EditCompanyVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

extension EditCompanyVC: CountriesListDelegate {
    func countrySelected(country: Country?) {
        if let country = country {
            if isUser {
                if let url = URL(string: country.imageUrl) {
                    cell.countryFlagImageView.af_setImage(withURL: url)
                }
                cell.countryCodeLabel.text =  "+" + country.code
                userCountryCode =  "+" + country.code
                userSelectedCountry = country
                cell.userSelectedCountry = country
                
                selectedRegion = nil
                cell.regionNameLabel.text = "region".localized()
                if #available(iOS 13.0, *) {
                    cell.regionNameLabel.textColor = .placeholderText
                } else {
                    cell.regionNameLabel.textColor = .lightGray
                }
            } else {
                if let url = URL(string: country.imageUrl) {
                    cell.companyCountryCodeFlag.af_setImage(withURL: url)
                }
                cell.companyCountryCodeLabel.text = "+" + country.code
                companyCountryCode =  "+" + country.code
                companySelectedCountry = country
                cell.companySelectedCountry = country
            }
        }
    }
}

extension EditCompanyVC: RegisterCompanyCellDelegate {
    func pickPlaceClicked() {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
    }
    
    func serviceChecked(checked: Bool, index: Int) {
        if checked {
            selectedServices.append((Singleton.getInstance().signUpData.categories.get(index))!)
        } else {
            selectedServices.remove(at: index)
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
        
        presentVC(alert)
    }
    
    func changeOwnerCountryCode() {
        showCountriesList(isUser: true)
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
        
        presentVC(alert)
    }
    
    func changeCompanyCountryCode() {
        showCountriesList(isUser: false)
    }
    
    func changeCountry() {
        let dropDown = DropDown()
        dropDown.anchorView = cell.countryView
        
        var dataSource = [String]()
        for country in countries ?? [] {
            dataSource.append(country.name)
        }
        
        dropDown.dataSource = dataSource
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self?.cell.countryNameLabel.text = item
            self?.cell.countryNameLabel.textColor = .black
            self?.selectedCountry = self?.countries?.get(index)
            
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
        if let _ = userSelectedCountry {
            let dropDown = DropDown()
            if let regions = userSelectedCountry?.regions, regions.count > 0 {
                dropDown.anchorView = cell.regionView
                var dataSource = [String]()
                for region in userSelectedCountry?.regions ?? [] {
                    dataSource.append(region.name)
                }
                
                dropDown.dataSource = dataSource
                dropDown.selectionAction = { [weak self] (index: Int, item: String) in
                    self?.cell.regionNameLabel.text = item
                    self?.cell.regionNameLabel.textColor = .black
                    self?.selectedRegion = self?.userSelectedCountry?.regions.get(index)
                }
                dropDown.direction = .any
                dropDown.show()
            } else {
                view.makeToast("noCities".localized())
            }
            
        } else {
            view.makeToast("selectCountryFirst".localized())
        }
    }
    
    func registerClicked() {
        if let userJson = Defaults[.user], let user = User(json: userJson)  {
            if cell.companyImageChoosen ?? false {
                if let companyName = cell.companyNameTextField.text, !companyName.isEmpty {
                    if let companyPhoneNumber = cell.companyPhoneNumberTextField.text, !companyPhoneNumber.isEmpty {
                        if companyPhoneNumber.isNumber() {
                            if let email = cell.companyEmail.text, !email.isEmpty {
                                if email.isEmail {
                                    if let _ = selectedCountry {
                                        if let _ = selectedRegion {
                                            if let detailedAddress = cell.detailedAddressTextField.text, !detailedAddress.isEmpty {
                                                if let traditionalNumber = cell.traditionalNumberTextField.text, !traditionalNumber.isEmpty {
                                                    if let _ = selectedLatitude, let _ = selectedLongitude {
                                                        presenter.editCompany(userPhoneNumber: user.phoneNumber, userName: user.name, userImage: (cell.userAvatarImageView.image?.jpegData(compressionQuality: 0.5))!, companyImage: (cell.companyAvatar.image?.jpegData(compressionQuality: 0.5))!, companyServices: selectedServices, companyName: companyName, companyTraditionalNumber: traditionalNumber, companyPhoneNumber: companyPhoneNumber, companyEmail: email, companyCountry: self.selectedCountry!, companyRegion: self.selectedRegion!, detailedAddress: detailedAddress, companyLatitude: self.selectedLatitude, companyLongitude: self.selectedLongitude, userSelectedCountry: self.userSelectedCountry!, companySelectedCountry: self.companySelectedCountry!)
                                                    } else {
                                                        view.makeToast("selectCompanyPlace".localized())
                                                    }
                                                } else {
                                                    view.makeToast("enterTraditionalnumber".localized())
                                                }
                                            } else {
                                                view.makeToast("enterDetailedAddress".localized())
                                            }
                                        } else {
                                            view.makeToast("enterSelectedRegion".localized())
                                        }
                                    } else {
                                        view.makeToast("enterSelectedCountry".localized())
                                    }
                                } else {
                                    view.makeToast("enterValidEmail".localized())
                                }
                            } else {
                                view.makeToast("enterEmail".localized())
                            }
                        } else {
                            view.makeToast("enterValidPhoneNumber".localized())
                        }
                    } else {
                        view.makeToast("enterCompanyPhoneNumber".localized())
                    }
                } else {
                    view.makeToast("enterCompanyName".localized())
                }
            } else {
                view.makeToast("enterCompanyAvatar".localized())
            }
        } else {
            if cell.userImageChoosen ?? false {
                if let fullName = cell.fullNameTextField.text, !fullName.isEmpty {
                    if let userPhoneNumber = cell.phoneNumberTextField.text, !userPhoneNumber.isEmpty {
                        if userPhoneNumber.isNumber() {
                            if cell.companyImageChoosen ?? false {
                                if let companyName = cell.companyNameTextField.text, !companyName.isEmpty {
                                    if let companyPhoneNumber = cell.companyPhoneNumberTextField.text, !companyPhoneNumber.isEmpty {
                                        if companyPhoneNumber.isNumber() {
                                            if let email = cell.companyEmail.text, !email.isEmpty {
                                                if email.isEmail {
                                                    if let _ = selectedCountry {
                                                        if let _ = selectedRegion {
                                                            if let detailedAddress = cell.detailedAddressTextField.text, !detailedAddress.isEmpty {
                                                                if let traditionalNumber = cell.traditionalNumberTextField.text, !traditionalNumber.isEmpty {
                                                                    if let _ = selectedLatitude, let _ = selectedLongitude {
                                                                        presenter.editCompany(userPhoneNumber: userPhoneNumber, userName: fullName, userImage: (cell.userAvatarImageView.image?.jpegData(compressionQuality: 0.5))!, companyImage: (cell.companyAvatar.image?.jpegData(compressionQuality: 0.5))!, companyServices: selectedServices, companyName: companyName, companyTraditionalNumber: traditionalNumber, companyPhoneNumber: companyPhoneNumber, companyEmail: email, companyCountry: self.selectedCountry!, companyRegion: self.selectedRegion!, detailedAddress: detailedAddress, companyLatitude: self.selectedLatitude, companyLongitude: self.selectedLongitude, userSelectedCountry: self.userSelectedCountry!, companySelectedCountry: self.companySelectedCountry!)
                                                                    } else {
                                                                        view.makeToast("selectCompanyPlace".localized())
                                                                    }
                                                                } else {
                                                                    view.makeToast("enterTraditionalnumber".localized())
                                                                }
                                                            } else {
                                                                view.makeToast("enterDetailedAddress".localized())
                                                            }
                                                        } else {
                                                            view.makeToast("enterSelectedRegion".localized())
                                                        }
                                                    } else {
                                                        view.makeToast("enterSelectedCountry".localized())
                                                    }
                                                } else {
                                                    view.makeToast("enterValidEmail".localized())
                                                }
                                            } else {
                                                view.makeToast("enterEmail".localized())
                                            }
                                        } else {
                                            view.makeToast("enterValidPhoneNumber".localized())
                                        }
                                    } else {
                                        view.makeToast("enterCompanyPhoneNumber".localized())
                                    }
                                } else {
                                    view.makeToast("enterCompanyName".localized())
                                }
                            } else {
                                view.makeToast("enterCompanyAvatar".localized())
                            }
                        } else {
                            view.makeToast("enterValidPhoneNumber".localized())
                        }
                    } else {
                        view.makeToast("enterPhoneField".localized())
                    }
                } else {
                    view.makeToast("enterFullName".localized())
                }
            } else {
                view.makeToast("enterAvatar".localized())
            }
        }
    }
    
    func backClicked() {
        navigationController?.popViewController(animated: true)
    }
}
