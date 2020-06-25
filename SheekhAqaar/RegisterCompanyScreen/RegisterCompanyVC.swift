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
import GoogleMaps
import GooglePlacePicker
import SwiftyUserDefaults

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
    var presenter: RegisterCompanyPresenter!
    var isUser: Bool!
    var selectedLatitude: Double!
    var selectedLongitude: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weakSelf = self
        
        presenter = Injector.provideRegisterCompanyPresenter()
        presenter.setView(view: self)
        
        if let _ = Defaults[.user] {
            
            for country in Singleton.getInstance().signUpData.countries {
                if country.id == User(json: Defaults[.user]!)?.countryId {
                    userSelectedCountry = country
                    break
                }
            }
        }
        
        companyDataTableView.dataSource = self
        companyDataTableView.delegate = self
        companyDataTableView.reloadData()
        
        getCurrentLocation()
    }
    
    func getCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 50
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
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

extension RegisterCompanyVC: RegisterCompanyView {
    func registerCompanySuccess(user: User) {
        Defaults[.user] = user.toJSON()
        if let companies = user.companies, companies.count > 0 {
            let company = companies[0]
            Defaults[.company] = company.toJSON()
        }
        
        self.view.makeToast("companyCreated".localized(), duration: 3) {
            self.navigator.navigateToHome()
        }
        
    }
    
    func failed(errorMessage: String) {
        self.view.makeToast(errorMessage)
    }
    
    func handleNoInternetConnection() {
        self.view.makeToast("noInternetConnection".localized())
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
        cell.categories = Singleton.getInstance().signUpData.categories
        cell.userSelectedCountry = userSelectedCountry
        cell.companySelectedCountry = companySelectedCountry
        cell.initializeCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let _ = Defaults[.user] {
            return UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 103) + (UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 5) * CGFloat(Singleton.getInstance().signUpData.categories.count))
        }
        
        return UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 125) + (UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 5) * CGFloat(Singleton.getInstance().signUpData.categories.count))
    }
}

extension RegisterCompanyVC: LocationSelectionDelegate {
    func locationSelected(address: Address) {
        cell.addressOnMapLabel.text = address.addressName
        self.selectedLatitude = address.latitude
        self.selectedLongitude = address.longitude
    }
}

extension RegisterCompanyVC: RegisterCompanyCellDelegate {
    func pickPlaceClicked() {
        self.navigator.navigateToAddressPickerWithMap(delegate: self)
    }
    
    func serviceChecked(checked: Bool, index: Int) {
        if checked {
            weakSelf?.selectedServices.append((Singleton.getInstance().signUpData.categories.get(index))!)
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
                self?.cell.regionNameLabel.textColor = .black
            } else {
                self?.cell.regionNameLabel.textColor = .lightGray
            }
        }
        dropDown.direction = .any
        dropDown.show()
    }
    
    func changeRegion() {
        if let _ = companySelectedCountry {
            let dropDown = DropDown()
            if let regions = companySelectedCountry?.regions, regions.count > 0 {
                dropDown.anchorView = weakSelf?.cell.regionView
                var dataSource = [String]()
                for region in regions {
                    dataSource.append(region.name)
                }
                
                dropDown.dataSource = dataSource
                dropDown.selectionAction = { [weak self] (index: Int, item: String) in
                    self?.cell.regionNameLabel.text = item
                    self?.cell.regionNameLabel.textColor = .black
                    self?.selectedRegion = self?.companySelectedCountry?.regions.get(index)
                }
                dropDown.direction = .any
                dropDown.show()
            } else {
                weakSelf?.view.makeToast("noCities".localized())
            }
            
        } else {
            weakSelf?.view.makeToast("selectCountryFirst".localized())
        }
    }
    
    func registerClicked() {
        
        weakSelf?.cell.userNameErrorImageView.isHidden = true
        weakSelf?.cell.userPhoneNumberErrorImageView.isHidden = true
        weakSelf?.cell.companyNameErrorImageView.isHidden = true
        weakSelf?.cell.traditionalNumberErrorImageView.isHidden = true
        weakSelf?.cell.companyPhoneNumberErrorImageView.isHidden = true
        weakSelf?.cell.companyEmailErrorImageView.isHidden = true
        weakSelf?.cell.companyDetailedAddresErrorImageView.isHidden = true
        
        if let userJson = Defaults[.user], let user = User(json: userJson)  {
            var errorDetected = false
            var taostViewed = false
             
            var companyName = ""
            var companyPhoneNumber = ""
            var email = ""
            var detailedAddress = ""
            var traditionalNumber = ""
            
//            if let companyImageChoosen = weakSelf?.cell.companyImageChoosen, !companyImageChoosen {
//                weakSelf?.view.makeToast("enterCompanyAvatar".localized())
//                errorDetected = true
//                taostViewed = true
//            }
            
            if let companyName = weakSelf?.cell.companyNameTextField.text, companyName.isEmpty {
                weakSelf?.cell.companyNameErrorImageView.isHidden = false
                errorDetected = true
            } else {
                companyName = (weakSelf?.cell.companyNameTextField.text)!
            }
            
            if let companyPhoneNumber = weakSelf?.cell.companyPhoneNumberTextField.text, companyPhoneNumber.isEmpty {
                weakSelf?.cell.companyPhoneNumberErrorImageView.isHidden = false
                errorDetected = true
            } else if let companyPhoneNumber = weakSelf?.cell.companyPhoneNumberTextField.text, !companyPhoneNumber.isNumber() {
                weakSelf?.view.makeToast("enterValidPhoneNumber".localized())
                taostViewed = true
                errorDetected = true
            } else {
                companyPhoneNumber = (weakSelf?.cell.companyPhoneNumberTextField.text)!
            }
            
            if let email = weakSelf?.cell.companyEmail.text, email.isEmpty {
                weakSelf?.cell.companyEmailErrorImageView.isHidden = false
                errorDetected = true
            } else if let email = weakSelf?.cell.companyEmail.text, !email.isEmail {
                weakSelf?.view.makeToast("enterValidEmail".localized())
                taostViewed = true
                errorDetected = true
            } else {
                email = (weakSelf?.cell.companyEmail.text)!
            }
            //
            if weakSelf?.selectedCountry == nil || weakSelf?.selectedRegion == nil || weakSelf?.selectedLatitude == nil || weakSelf?.selectedLongitude == nil  {
                errorDetected = true
            }
            
//            if let detailedAddress = weakSelf?.cell.detailedAddressTextField.text, detailedAddress.isEmpty {
//                weakSelf?.cell.companyDetailedAddresErrorImageView.isHidden = false
//                errorDetected = true
//            } else {
//                detailedAddress = (weakSelf?.cell.detailedAddressTextField.text)!
//            }
//
//            if let traditionalNumber = weakSelf?.cell.traditionalNumberTextField.text, traditionalNumber.isEmpty {
//                weakSelf?.cell.traditionalNumberErrorImageView.isHidden = false
//                errorDetected = true
//            } else {
//                traditionalNumber = (weakSelf?.cell.traditionalNumberTextField.text)!
//            }
            
            if errorDetected {
                if !taostViewed {
                    weakSelf?.view.makeToast("emptyFieldsError".localized())
                }
            } else {
                weakSelf?.presenter.registerCompany(userPhoneNumber: user.phoneNumber, userName: user.name, userImage: (weakSelf?.cell.userAvatarImageView.image?.jpegData(compressionQuality: 0.5))!, companyImage: (weakSelf?.cell.companyAvatar.image?.jpegData(compressionQuality: 0.5))!, companyServices: weakSelf!.selectedServices, companyName: companyName, companyTraditionalNumber: traditionalNumber, companyPhoneNumber: companyPhoneNumber, companyEmail: email, companyCountry: self.selectedCountry!, companyRegion: self.selectedRegion!, detailedAddress: detailedAddress, companyLatitude: self.selectedLatitude, companyLongitude: self.selectedLongitude, userSelectedCountry: self.userSelectedCountry!, companySelectedCountry: self.companySelectedCountry!)
            }
        } else {
            
            var errorDetected = false
            var taostViewed = false
             
            var fullName = ""
            var userPhoneNumber = ""
            var companyName = ""
            var companyPhoneNumber = ""
            var email = ""
            var detailedAddress = ""
            var traditionalNumber = ""
            
//            if let userImageChoosen = weakSelf?.cell.userImageChoosen, !userImageChoosen {
//                weakSelf?.view.makeToast("enterAvatar".localized())
//                errorDetected = true
//                taostViewed = true
//            }
            
            if let fullName = weakSelf?.cell.fullNameTextField.text, fullName.isEmpty {
                weakSelf?.cell.userNameErrorImageView.isHidden = false
                errorDetected = true
            } else {
                fullName = (weakSelf?.cell.fullNameTextField.text)!
            }
            
            if let userPhoneNumber = weakSelf?.cell.phoneNumberTextField.text, userPhoneNumber.isEmpty {
                weakSelf?.cell.userPhoneNumberErrorImageView.isHidden = false
                errorDetected = true
            } else if let userPhoneNumber = weakSelf?.cell.phoneNumberTextField.text, userPhoneNumber.isNumber() {
                weakSelf?.view.makeToast("enterValidPhoneNumber".localized())
                taostViewed = true
                errorDetected = true
            } else {
                userPhoneNumber = (weakSelf?.cell.phoneNumberTextField.text)!
            }
            
//            if let companyImageChoosen = weakSelf?.cell.companyImageChoosen, !companyImageChoosen {
//                weakSelf?.view.makeToast("enterCompanyAvatar".localized())
//                errorDetected = true
//                taostViewed = true
//            }
            
            if let companyName = weakSelf?.cell.companyNameTextField.text, companyName.isEmpty {
                weakSelf?.cell.companyNameErrorImageView.isHidden = false
                errorDetected = true
            } else {
                companyName = (weakSelf?.cell.companyNameTextField.text)!
            }
            
            if let companyPhoneNumber = weakSelf?.cell.companyPhoneNumberTextField.text, companyPhoneNumber.isEmpty {
                weakSelf?.cell.companyPhoneNumberErrorImageView.isHidden = false
                errorDetected = true
            } else if let companyPhoneNumber = weakSelf?.cell.companyPhoneNumberTextField.text, !companyPhoneNumber.isNumber() {
                weakSelf?.view.makeToast("enterValidPhoneNumber".localized())
                taostViewed = true
                errorDetected = true
            } else {
                companyPhoneNumber = (weakSelf?.cell.companyPhoneNumberTextField.text)!
            }
            
            if let email = weakSelf?.cell.companyEmail.text, email.isEmpty {
                weakSelf?.cell.companyEmailErrorImageView.isHidden = true
                errorDetected = true
            } else if let email = weakSelf?.cell.companyEmail.text, !email.isEmail {
                weakSelf?.view.makeToast("enterValidEmail".localized())
                taostViewed = true
                errorDetected = true
            } else {
                email = (weakSelf?.cell.companyEmail.text)!
            }
            
            if weakSelf?.selectedCountry == nil || weakSelf?.selectedRegion == nil || weakSelf?.selectedLatitude == nil || weakSelf?.selectedLongitude == nil  {
                errorDetected = true
            }
            
//            if let detailedAddress = weakSelf?.cell.detailedAddressTextField.text, detailedAddress.isEmpty {
//                weakSelf?.cell.companyDetailedAddresErrorImageView.isHidden = false
//                errorDetected = true
//            } else {
//                detailedAddress = (weakSelf?.cell.detailedAddressTextField.text)!
//            }
//            
//            if let traditionalNumber = weakSelf?.cell.traditionalNumberTextField.text, traditionalNumber.isEmpty {
//                weakSelf?.cell.traditionalNumberErrorImageView.isHidden = false
//                errorDetected = true
//            } else {
//                traditionalNumber = (weakSelf?.cell.traditionalNumberTextField.text)!
//            }
            
            if errorDetected {
                if !taostViewed {
                    weakSelf?.view.makeToast("emptyFieldsError".localized())
                }
            } else {
                weakSelf?.presenter.registerCompany(userPhoneNumber: userPhoneNumber, userName: fullName, userImage: (weakSelf?.cell.userAvatarImageView.image?.jpegData(compressionQuality: 0.5))!, companyImage: (weakSelf?.cell.companyAvatar.image?.jpegData(compressionQuality: 0.5))!, companyServices: weakSelf!.selectedServices, companyName: companyName, companyTraditionalNumber: traditionalNumber, companyPhoneNumber: companyPhoneNumber, companyEmail: email, companyCountry: self.selectedCountry!, companyRegion: self.selectedRegion!, detailedAddress: detailedAddress, companyLatitude: self.selectedLatitude, companyLongitude: self.selectedLongitude, userSelectedCountry: self.userSelectedCountry!, companySelectedCountry: self.companySelectedCountry!)
            }
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

extension RegisterCompanyVC: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if Singleton.getInstance().currentLocation == nil || (Singleton.getInstance().currentLocation.coordinate.latitude != locations.last!.coordinate.latitude && Singleton.getInstance().currentLocation.coordinate.longitude != locations.last!.coordinate.longitude) {
            Singleton.getInstance().currentLocation = locations.last!
            print("Location: \(Singleton.getInstance().currentLocation!)")
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .notDetermined:
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .denied:
            print("Location access was restricted.")
            let enableAction = UIAlertAction(title: "enable".localized(), style: .default) { (_) in
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            }
            
            let cancelAction = UIAlertAction(title: "cancel".localized(), style: .default) { [weak self] (_) in
                self?.alertController.dismissVC(completion: nil)
            }
            
            alertController = UiHelpers.createAlertView(title: "locationServicesDisabledTitle".localized(), message: "locationServicesDisabledMessage".localized(), actions: [enableAction, cancelAction])
            
            presentVC(alertController)
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        default:
            break
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension RegisterCompanyVC: CountriesListDelegate {
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
                
                selectedRegion = nil
                cell.regionNameLabel.text = "region".localized()
                if #available(iOS 13.0, *) {
                    cell.regionNameLabel.textColor = .placeholderText
                } else {
                    cell.regionNameLabel.textColor = .lightGray
                }
            }
        }
    }
}

