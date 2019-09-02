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
    func showFarshLevels()
    func facilityChecked(checked: Bool, index: Int)
    func changeNumberOfBathrooms(newNumber: Int)
    func changeNumberOfRooms(newNumber: Int)
    func publishAd(ad: Ad, images: [Data])
}

class CreateAdCell: UITableViewCell {

    public static let identifier = "CreateAdCell"
    
    @IBOutlet weak var numberOfAddedPhotosLabel: UILabel!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var addressTextField: LocalizedTextField!
    @IBOutlet weak var priceTextField: LocalizedTextField!
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var currencyLabel: LocalizedLabel!
    @IBOutlet weak var adDetailsTextField: LocalizedTextField!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: LocalizedLabel!
    @IBOutlet weak var adTypeView: UIView!
    @IBOutlet weak var adTypeLabel: LocalizedLabel!
    @IBOutlet weak var areaLabel: LocalizedTextField!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var countryLabel: LocalizedLabel!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var cityLabel: LocalizedLabel!
    @IBOutlet weak var buildingLocationTextField: LocalizedTextField!
    @IBOutlet weak var detectLocationOnGoogleMaps: UIView!
    @IBOutlet weak var farshLevelView: UIView!
    @IBOutlet weak var farshLevelLabel: LocalizedLabel!
    @IBOutlet weak var increaseNumberOfRoomsLabel: UILabel!
    @IBOutlet weak var numberOfRoomsLabel: UILabel!
    @IBOutlet weak var decreaseNumberOfRoomsLabel: UILabel!
    @IBOutlet weak var increaseNumberOfBathroomsLabel: UILabel!
    @IBOutlet weak var numberOfBathroomsLabel: UILabel!
    @IBOutlet weak var decreaseNumberOfBathroomsLabel: UILabel!
    @IBOutlet weak var additionalFacilitiesTableView: UITableView!
    @IBOutlet weak var publishAddButton: UIButton!
    
    var countries = [Country]()
    var categories = [Category]()
    var adTypes = [AdType]()
    var farshLevels = [FarshLevel]()
    var currencies = [Currency]()
    var additionalFacilities = [AdditionalFacility]()
    var cities = [City]()
    
    var delegate: CreateAdCellDelegate!
    
    var images = [UIImage]()
    
    var numberOfRooms = 0
    var numberOfBathrooms = 0
    
    public func initializeCell() {
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        photosCollectionView.reloadData()
        
        additionalFacilitiesTableView.dataSource = self
        additionalFacilitiesTableView.delegate = self
        additionalFacilitiesTableView.reloadData()
        
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
        
        increaseNumberOfRoomsLabel.addTapGesture { [weak self] (_) in
            self?.numberOfRooms = (self?.numberOfRooms ?? 0) + 1
            self?.delegate.changeNumberOfRooms(newNumber: self?.numberOfRooms ?? 0)
            if let count = self?.numberOfRooms, count == 0 {
                self?.numberOfRoomsLabel.text = "numberOfRooms".localized()
            } else {
                self?.numberOfRoomsLabel.text = "\(self?.numberOfRooms ?? 0)"
            }
        }
        
        decreaseNumberOfRoomsLabel.addTapGesture { [weak self] (_) in
            if let count = self?.numberOfRooms {
                if count > 0 {
                    self?.numberOfRooms = (self?.numberOfRooms ?? 1) - 1
                    if let c = self?.numberOfRooms, c == 0 {
                        self?.numberOfRoomsLabel.text = "numberOfRooms".localized()
                    } else {
                        self?.delegate.changeNumberOfRooms(newNumber: self?.numberOfRooms ?? 0)
                        self?.numberOfRoomsLabel.text = "\(self?.numberOfRooms ?? 0)"
                    }
                } else {
                    self?.numberOfRoomsLabel.text = "numberOfRooms".localized()
                }
            }
        }
        
        increaseNumberOfBathroomsLabel.addTapGesture { [weak self] (_) in
            self?.numberOfBathrooms = (self?.numberOfBathrooms ?? 0) + 1
            self?.delegate.changeNumberOfBathrooms(newNumber: self?.numberOfBathrooms ?? 0)
            if let count = self?.numberOfBathrooms, count == 0 {
                self?.numberOfBathroomsLabel.text = "numberOfBathrooms".localized()
            } else {
                self?.numberOfBathroomsLabel.text = "\(self?.numberOfBathrooms ?? 0)"
            }
        }
        
        decreaseNumberOfBathroomsLabel.addTapGesture { [weak self] (_) in
            if let count = self?.numberOfBathrooms {
                if count > 0 {
                    self?.numberOfBathrooms = (self?.numberOfBathrooms ?? 1) - 1
                    if let c = self?.numberOfBathrooms, c == 0 {
                        self?.numberOfBathroomsLabel.text = "numberOfBathrooms".localized()
                    } else {
                        self?.delegate.changeNumberOfBathrooms(newNumber: self?.numberOfBathrooms ?? 0)
                        self?.numberOfBathroomsLabel.text = "\(self?.numberOfBathrooms ?? 0)"
                    }
                } else {
                    self?.numberOfBathroomsLabel.text = "numberOfBathrooms".localized()
                }
            }
        }
        
        cityView.addTapGesture { [weak self] (_) in
            self?.delegate.showCities()
        }
        
        farshLevelView.addTapGesture { [weak self] (_) in
            self?.delegate.showFarshLevels()
        }
        
        publishAddButton.addTapGesture { [weak self](_) in
            let ad = Ad()
            self?.delegate.publishAd(ad: ad, images: [])
        }
    }
    
}

extension CreateAdCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdPhotoCell
            .identifier, for: indexPath) as! AdPhotoCell
        
        if indexPath.row == 0 {
            cell.adPhotoImageView.image = UIImage(named: "bed")
        } else {
            cell.adPhotoImageView.image = images.get(indexPath.row)
        }
        
        return cell
    }
}

extension CreateAdCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return additionalFacilities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChooseAdditionalFacilityCell.identifier, for: indexPath) as! ChooseAdditionalFacilityCell
        cell.index = indexPath.row
        cell.additionalFacility = self.additionalFacilities.get(indexPath.row)
        cell.delegate = self
        cell.populateData()
        return cell
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
