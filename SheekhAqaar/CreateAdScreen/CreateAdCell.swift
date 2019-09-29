//
//  CreateAdCell.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/2/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

public protocol CreateAdCellDelegate: class {
    func showCurrencies()
    func showCategories()
    func showAdTypes()
    func showCountries()
    func showCities()
    func facilityChecked(checked: Bool, index: Int)
    func publishAd(adTitle: String, additionalFacilities: [String], adDetailsItems: [String], images: [Data])
    func addImages()
    func getLocationFromGoogleMaps()
}

class CreateAdCell: UITableViewCell {

    public static let identifier = "CreateAdCell"
    
    @IBOutlet weak var numberOfAddedPhotosLabel: UILabel!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var adTitleTextField: LocalizedTextField!
    @IBOutlet weak var priceTextField: LocalizedTextField!
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var currencyLabel: LocalizedLabel!
    @IBOutlet weak var adDetailsTextField: LocalizedTextField!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: LocalizedLabel!
    @IBOutlet weak var adTypeView: UIView!
    @IBOutlet weak var adTypeLabel: LocalizedLabel!
    @IBOutlet weak var areaTextField: LocalizedTextField!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var countryLabel: LocalizedLabel!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var cityLabel: LocalizedLabel!
    @IBOutlet weak var buildingLocationLabel: LocalizedLabel!
    @IBOutlet weak var detectLocationOnGoogleMaps: UIView!
    
    @IBOutlet weak var adDetailsTableView: UITableView!
    @IBOutlet weak var additionalFacilitiesTableView: UITableView!
    @IBOutlet weak var publishAddButton: UIButton!

    var adDetailsItems = [AdDetailsItem]()
    var additionalFacilities = [AdditionalFacility]()
    
    @IBOutlet weak var addImagesButton: LocalizedButton!
    var delegate: CreateAdCellDelegate!
    
    var selectedImages = [UIImage]()
    
    public func initializeCell() {
        if let layout = photosCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        photosCollectionView.reloadData()
        
        additionalFacilitiesTableView.dataSource = self
        additionalFacilitiesTableView.delegate = self
        additionalFacilitiesTableView.reloadData()
        
        adDetailsTableView.dataSource = self
        adDetailsTableView.delegate = self
        adDetailsTableView.reloadData()
        
        currencyView.addTapGesture { [weak self] (_) in
            self?.delegate.showCurrencies()
        }
        
        categoryView.addTapGesture { [weak self] (_) in
            self?.delegate.showCategories()
        }
        
        adTypeView.addTapGesture { [weak self] (_) in
            self?.delegate.showAdTypes()
        }
        
        categoryView.addTapGesture { [weak self] (_) in
            self?.delegate.showCategories()
        }
        
        countryView.addTapGesture { [weak self] (_) in
            self?.delegate.showCountries()
        }
        
        cityView.addTapGesture { [weak self] (_) in
            self?.delegate.showCities()
        }
        
        detectLocationOnGoogleMaps.addTapGesture { [weak self](_) in
            self?.delegate.getLocationFromGoogleMaps()
        }
        
        publishAddButton.addTapGesture { [weak self](_) in
            if self?.selectedImages.count ?? 0 >= 3 {
                if let adTitle = self?.adTitleTextField.text, !adTitle.isEmpty {
                    if let _ = self?.priceTextField.text {
                        if let _ = self?.adDetailsTextField.text {
                            if let _ = self?.areaTextField.text {
                                var adDetailsItemsStrings  = [String]()
                                var imagesData = [Data]()
                                
                                var index = 0
                                
                                
                                for item in self?.adDetailsItems ?? [] {
                                    var name = ""
                                    
                                    let cell = self?.adDetailsTableView.cellForRow(at: IndexPath(row: index, section: 0))
                                    if let cell = cell as? AdDetailsWithoutSpinnerCell {
                                        name = "\(item.name!): \(cell.valueTextField.text!)"
                                    } else if let cell = cell as? AdDetailsWithSpinnerCell {
                                        name = "\(item.name!): \(cell.valueLabel.text!)"
                                    }
                                    adDetailsItemsStrings.append(name)
                                    index = index + 1
                                }
                                    
                                for image in self?.selectedImages ?? [] {
                                    imagesData.append(image.jpegData(compressionQuality: 0.1)!)
                                }
                                    
                                self?.delegate.publishAd(adTitle: adTitle, additionalFacilities: [], adDetailsItems: adDetailsItemsStrings, images: imagesData)
                            } else {
                                self?.contentView.makeToast("enterArea".localized())
                            }
                        } else {
                            self?.contentView.makeToast("enterDetails".localized())
                        }
                    } else {
                        self?.contentView.makeToast("enterPrice".localized())
                    }
                } else {
                    self?.contentView.makeToast("enterAdTitle".localized())
                }
            } else {
                self?.contentView.makeToast("atLeast3Images".localized())
            }
        }
        
        addImagesButton.addTapGesture { [weak self](_) in
            self?.delegate.addImages()
        }
    }
    
}

extension CreateAdCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdPhotoCell
            .identifier, for: indexPath) as! AdPhotoCell
        
        cell.adPhotoImageView.image = selectedImages.get(indexPath.row)
        cell.delegate = self
        cell.index = indexPath.row
        cell.configureRemoveIcon()
        return cell
    }
}

extension CreateAdCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == additionalFacilitiesTableView {
            return additionalFacilities.count
        } else if tableView == adDetailsTableView {
            return adDetailsItems.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if tableView == additionalFacilitiesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: ChooseAdditionalFacilityCell.identifier, for: indexPath) as! ChooseAdditionalFacilityCell
            cell.index = indexPath.row
            cell.additionalFacility = self.additionalFacilities.get(indexPath.row)
            cell.delegate = self
            cell.populateData()
            return cell
         } else if tableView == adDetailsTableView {
            let adDetailsItem = adDetailsItems.get(indexPath.row)
            if adDetailsItem?.spinnerDataArray.count ?? 0 > 0 {
               let cell = tableView.dequeueReusableCell(withIdentifier: AdDetailsWithSpinnerCell.identifier, for: indexPath) as! AdDetailsWithSpinnerCell
                cell.adDetailsItem = adDetailsItem
                cell.populateData()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: AdDetailsWithoutSpinnerCell.identifier, for: indexPath) as! AdDetailsWithoutSpinnerCell
                cell.adDetailsItem = adDetailsItem
                cell.populateData()
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 4)
    }
}

extension CreateAdCell: ChooseAdditionalFacilityCellDelegate {
    func facilityChecked(checked: Bool, index: Int) {
        self.delegate.facilityChecked(checked: checked, index: index)
        self.additionalFacilities.get(index)?.isChecked = checked
        self.additionalFacilitiesTableView.reloadData()
    }
}

extension CreateAdCell: AdPhotoCellDelegate {
    func removeImage(index: Int) {
        self.selectedImages.remove(at: index)
        photosCollectionView.reloadData()
    }
}
