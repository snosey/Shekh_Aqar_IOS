//
//  EditAdVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 10/2/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import DropDown
import GooglePlacePicker
import SwiftyUserDefaults

class EditAdVC: BaseVC {

    public class func buildVC(ad: Ad) -> EditAdVC {
        let storyboard = UIStoryboard(name: "EditAdStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditAdVC") as! EditAdVC
        vc.ad = ad
        return vc
    }
    
    @IBOutlet weak var backIcon: UIImageView!
    @IBOutlet weak var adDataTableView: UITableView!
    
    var ad: Ad!
    
    var presenter: EditAdPresenter!
    
    var countries = Singleton.getInstance().signUpData.countries
    var selectedCountry: Country!
    
    var categories = Singleton.getInstance().mainCategories
    var selectedCategory: Category!
    
    var adTypes = [Category]()
    var selectedAdType: Category!
    
    var adDetailsItems = [AdDetailsItem]()
    
    var currencies = [Currency]()
    var selectedCurrency: Currency!
    
    var additionalFacilities = [AdditionalFacility]()
    var selectedAddtionalFacilities = [AdditionalFacility]()
    
    var regions = [Region]()
    var selectedRegion: Region!
    
    var selectedLatitude: Double!
    var selectedLongitude: Double!
    
    var cell: CreateAdCell!
    
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backIcon.addTapGesture { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        presenter = Injector.provideEditAdPresenter()
        presenter.setView(view: self)
        presenter.getCreateAdData(subCategoryId: ad.subCategoryId, latitude: Singleton.getInstance().currentLatitude, longitude: Singleton.getInstance().currentLongitude)
        
        adDataTableView.delegate = self
        adDataTableView.dataSource = self
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

extension EditAdVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true, completion: { [weak self]() -> Void in
            if let chosenImage = info[.originalImage] as? UIImage{
                //use image
                self?.cell.selectedImages.append(chosenImage)
                self?.cell.photosCollectionView.reloadData()
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true)
    }
}

extension EditAdVC: EditAdView {
    func getCreateAdDataSuccess(createAdData: CreateAdData) {
        self.adDetailsItems = createAdData.adDetailsItems
        self.currencies = createAdData.currencies
        self.additionalFacilities = createAdData.additionalFacilities
        
        cell.additionalFacilities = additionalFacilities
        cell.additionalFacilitiesTableView.reloadData()
        
        cell.adDetailsItems = adDetailsItems
        cell.adDetailsTableView.reloadData()
        
        adDataTableView.reloadData()
        
        cell.adImages = ad.adImages
        
        if ad.company.id != 0 {
            for country in countries ?? [] {
                for region in country.regions {
                    if ad.company.regionId == region.id {
                        selectedRegion = region
                        selectedCountry = country
                    }
                }
            }
        } else {
            for country in countries ?? [] {
                if country.id == ad.user.countryId {
                    selectedCountry = country
                    selectedRegion = country.regions[0]
                }
            }
        }        
        
        selectedAdType = ad.subCategory
        selectedCurrency = ad.currency
        selectedLatitude = Double(ad.latitude)
        selectedLongitude = Double(ad.longitude)
        selectedAddtionalFacilities = ad.additionalFacilities
        
        var mainCategoryName = ""
        
        for category in categories {
            if category.id == ad.subCategory.mainCategoryId {
                mainCategoryName = category.name
                selectedCategory = category
            }
        }
        
        cell.showSelectedData(ad: ad, selectedCountry: selectedCountry, selectedRegion: selectedRegion, mainCategoryName: mainCategoryName)
    }
    
    func editAdSuccess() {
        self.view.makeToast("editAdSuccess".localized(), duration: 2) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func failed(errorMessage: String) {
        self.view.makeToast(errorMessage)
    }
    
    func handleNoInternetConnection() {
        self.view.makeToast("noInternetConnection".localized())
    }
}

extension EditAdVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: CreateAdCell.identifier, for: indexPath) as! CreateAdCell
        cell.selectionStyle = .none
        cell.isEditAd = true
        cell.delegate = self
        cell.initializeCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 80)
        for _ in additionalFacilities {
            height = height + UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 4)
        }
        for _ in adDetailsItems {
            height = height + UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 4)
        }
        return height
    }
}

extension EditAdVC: CreateAdCellDelegate {
    
    func addImages() {
        var alert: UIAlertController!
        
        let photoGalleryAction = UIAlertAction(title: "photoGallery".localized(), style: .default) { [weak self](_) in
            self?.openPhotoGallery()
        }
        
        let cameraAction = UIAlertAction(title: "camera".localized(), style: .cancel) { [weak self](_) in
            self?.openCamera()
        }
        
        alert = UiHelpers.createAlertView(title: "chooseMediaTitle".localized(), message: "chooseMediaMessage".localized(), actions: [photoGalleryAction, cameraAction])
        
        presentVC(alert)
    }
    
    
    func editAd(ad: Ad, adDetailsItems: [AdDetailsItem], images: [Data], imagesToBeRemoved: [Data]) {
        if selectedCategory != nil {
            if selectedAdType != nil {
                if selectedCurrency != nil {
                   if selectedLatitude != nil && selectedLongitude != nil {
                    
                       let user = User(json: Defaults[.user]!)
                    
                       ad.additionalFacilities = self.selectedAddtionalFacilities
                       ad.detailedAddress = cell.buildingLocationLabel.text
                       ad.currencyId = selectedCurrency.id
                       ad.currency = selectedCurrency
                       ad.subCategory = selectedAdType
                       ad.subCategoryId = selectedAdType.id
                       ad.userId = user?.id
                       ad.user = user
                       ad.latitude = String(selectedLatitude)
                       ad.longitude = String(selectedLongitude)
                       ad.viewCount = 0
                    
                       presenter.editAd(ad: ad, adDetailsItems: adDetailsItems, images: images, imagesToBeRemoved: imagesToBeRemoved)
                   } else {
                       view.makeToast("chooseLocationFirst".localized())
                   }
                } else {
                    view.makeToast("selectCurrencyFirst".localized())
                }
            } else {
                view.makeToast("selectAdTypeFirst".localized())
            }
        } else {
            view.makeToast("selectCategoryFirst".localized())
        }
    }
    
    func showCurrencies() {
        let dropDown = DropDown()
        if currencies.count > 0 {
            dropDown.anchorView = cell.currencyView
            var dataSource = [String]()
            for currency in currencies {
                dataSource.append(currency.name)
            }
            
            dropDown.dataSource = dataSource
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in
                self?.cell.currencyLabel.text = item
                self?.cell.currencyLabel.textColor = .black
                self?.selectedCurrency = self?.currencies.get(index)
            }
            dropDown.direction = .any
            dropDown.show()
        } else {
            view.makeToast("noCurrencies".localized())
        }
    }
    
    func publishAd(ad: Ad, adDetailsItems: [AdDetailsItem], images: [Data]) {
        
    }
    
    func showCategories() {
        
        let dropDown = DropDown()
        if categories.count > 0 {
            dropDown.anchorView = cell.categoryView
            var dataSource = [String]()
            for category in categories {
                dataSource.append(category.name)
            }
            
            dropDown.dataSource = dataSource
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in
                self?.cell.categoryLabel.text = item
                self?.cell.categoryLabel.textColor = .black
                self?.selectedCategory = self?.categories.get(index)
                
                self?.adTypes = self?.selectedCategory.subCategories ?? []
                self?.selectedAdType = nil
                self?.cell.adTypeLabel.text = "adType".localized()
                if #available(iOS 13.0, *) {
                    self?.cell.adTypeLabel.textColor = .placeholderText
                } else {
                    self?.cell.adTypeLabel.textColor = .lightGray
                }
            }
            dropDown.direction = .any
            dropDown.show()
        } else {
            view.makeToast("noCategories".localized())
        }
    }
    
    func showAdTypes() {
        if let _ = selectedCategory {
            let dropDown = DropDown()
            if adTypes.count > 0 {
                dropDown.anchorView = cell.adTypeView
                var dataSource = [String]()
                for adType in adTypes {
                    dataSource.append(adType.name)
                }
                
                dropDown.dataSource = dataSource
                dropDown.selectionAction = { [weak self] (index: Int, item: String) in
                    self?.cell.adTypeLabel.text = item
                    self?.cell.adTypeLabel.textColor = .black
                    self?.selectedAdType = self?.adTypes.get(index)
                    
                    self?.presenter.getCreateAdData(subCategoryId: self?.selectedAdType.id ?? 0, latitude: Singleton.getInstance().currentLatitude, longitude: Singleton.getInstance().currentLongitude)
                    if let _ = self?.selectedAddtionalFacilities {
                        self?.selectedAddtionalFacilities.removeAll()
                    }
                    
                }
                dropDown.direction = .any
                dropDown.show()
            } else {
                view.makeToast("noCities".localized())
            }
        } else {
            view.makeToast("selectCategoryFirst".localized())
        }
    }
    
    func showCountries() {
        let dropDown = DropDown()
        if let countries = countries, countries.count > 0 {
            dropDown.anchorView = cell.countryView
            var dataSource = [String]()
            for country in countries {
                dataSource.append(country.name)
            }
            
            dropDown.dataSource = dataSource
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in
                self?.cell.countryLabel.text = item
                self?.cell.countryLabel.textColor = .black
                self?.selectedCountry = countries.get(index)
                
                self?.regions = self?.selectedCountry.regions ?? []
                self?.selectedRegion = nil
                self?.cell.cityLabel.text = "city".localized()
                if #available(iOS 13.0, *) {
                    self?.cell.cityLabel.textColor = .placeholderText
                } else {
                    self?.cell.cityLabel.textColor = .lightGray
                }
            }
            dropDown.direction = .any
            dropDown.show()
        } else {
            view.makeToast("noCountries".localized())
        }
    }
    
    func showCities() {
        if let _ = selectedCountry {
            let dropDown = DropDown()
            if regions.count > 0 {
                dropDown.anchorView = cell.cityView
                var dataSource = [String]()
                for region in regions {
                    dataSource.append(region.name)
                }
                
                dropDown.dataSource = dataSource
                dropDown.selectionAction = { [weak self] (index: Int, item: String) in
                    self?.cell.cityLabel.text = item
                    self?.cell.cityLabel.textColor = .black
                    self?.selectedRegion = self?.regions.get(index)
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
    
    func facilityChecked(checked: Bool, index: Int) {
        if checked {
            selectedAddtionalFacilities.append(additionalFacilities.get(index)!)
        } else {
            let additionalFacilityId = additionalFacilities.get(index)!.id
            selectedAddtionalFacilities.removeAll { (facility) -> Bool in
                return facility.id == additionalFacilityId
            }
        }
    }
    
    func getLocationFromGoogleMaps() {
        self.navigator.navigateToAddressPickerWithMap(delegate: self)
//        let config = GMSPlacePickerConfig(viewport: nil)
//        let placePicker = GMSPlacePickerViewController(config: config)
//        placePicker.delegate = self
//        present(placePicker, animated: true, completion: nil)
    }
}

extension EditAdVC: LocationSelectionDelegate {
    func locationSelected(address: Address) {
        cell.buildingLocationLabel.text = address.addressName
        self.selectedLatitude = address.latitude
        self.selectedLongitude = address.longitude
    }
}

//extension EditAdVC: GMSPlacePickerViewControllerDelegate {
//    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
//        viewController.dismiss(animated: true, completion: nil)
//
//
//    }
//
//    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
//        // Dismiss the place picker, as it cannot dismiss itself.
//        viewController.dismiss(animated: true, completion: nil)
//
//        print("No place selected")
//    }
//}
