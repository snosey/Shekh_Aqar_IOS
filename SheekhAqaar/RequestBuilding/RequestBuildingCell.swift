//
//  RequestBuildingCell.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/28/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

public protocol RequestBuildingCellDelegate: class {
    func showCurrencies()
    func showCategories()
    func showAdTypes()
    func showCountries()
    func showCities()
    func facilityChecked(checked: Bool, index: Int)
    func requestBuilding(adTitle: String, additionalFacilities: [String], adDetailsItems: [String])
    func getLocationFromGoogleMaps()
}

class RequestBuildingCell: UITableViewCell {

    public static let identifier = "RequestBuildingCell"
    
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
    @IBOutlet weak var requestBuildingButton: UIButton!
    
    var adDetailsItems = [AdDetailsItem]()
    var additionalFacilities = [AdditionalFacility]()
    
    public var delegate: RequestBuildingCellDelegate!

    public func initializeCell() {
        
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
        
        requestBuildingButton.addTapGesture { [weak self](_) in
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
                                
                                self?.delegate.requestBuilding(adTitle: adTitle, additionalFacilities: [], adDetailsItems: adDetailsItemsStrings)
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
        }
    }
}

extension RequestBuildingCell: UITableViewDataSource, UITableViewDelegate {
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

extension RequestBuildingCell: ChooseAdditionalFacilityCellDelegate {
    func facilityChecked(checked: Bool, index: Int) {
        self.delegate.facilityChecked(checked: checked, index: index)
        self.additionalFacilities.get(index)?.isChecked = checked
        self.additionalFacilitiesTableView.reloadData()
    }
}
