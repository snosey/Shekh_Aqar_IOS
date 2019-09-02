//
//  CreateAdVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/30/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

class CreateAdVC: BaseVC {

    public class func buildVC() -> CreateAdVC {
        let storyboard = UIStoryboard(name: "CreateAdStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateAdVC") as! CreateAdVC
        return vc
    }
    
    @IBOutlet weak var createAdTableView: UITableView!
    @IBOutlet weak var backIcon: UIImageView!
    
    var presenter: CreateAdPresenter!
    
    var countries = [Country]()
    var selectedCountry: Country!
    
    var categories = [Category]()
    var selectedCategory: Category!
    
    var adTypes = [AdType]()
    var selectedAdType: AdType!
    
    var farshLevels = [FarshLevel]()
    var selectedFarshLevel: FarshLevel!
    
    var currencies = [Currency]()
    var selectedCurrency: Currency!
    
    var additionalFacilities = [AdditionalFacility]()
    var selectedAddtionalFacility: AdditionalFacility!
    
    var cities = [City]()
    var selectedCity: City!
    
    var cell: CreateAdCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backIcon.addTapGesture { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        presenter = Injector.provideCreateAdPresenter()
        presenter.setView(view: self)
        presenter.getCountries()
        
        createAdTableView.delegate = self
        createAdTableView.dataSource = self
    }
}

extension CreateAdVC: CreateAdView {
    func getCountriesSuccess(countries: [Country]) {
        self.countries = countries
        presenter.getCategories()
    }
    
    func getCitiesSuccess(cities: [City]) {
        self.cities = cities
        cell.cities = cities
    }
    
    func getCategoriesSuccess(categories: [Category]) {
        self.categories = categories
        presenter.getAdTypes()
    }
    
    func getAdTypesSuccess(adTypes: [AdType]) {
        self.adTypes = adTypes
        presenter.getFarshLevels()
    }
    
    func getFarshLevelsSuccess(levels: [FarshLevel]) {
        self.farshLevels = levels
        presenter.getCurrencies()
    }
    
    func getCurrenciesSuccess(currencies: [Currency]) {
        self.currencies = currencies
        presenter.getAdditionalFacilities()
    }
    
    func getAdditionalFacilitiesSuccess(additionalFacilities: [AdditionalFacility]) {
        self.additionalFacilities = additionalFacilities
        createAdTableView.reloadData()
    }
    
    func publishAdSuccess() {
        self.view.makeToast("publishAdSuccess".localized(), duration: 2) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func failed(errorMessage: String) {
        self.view.makeToast(errorMessage)
    }
    
    func handleNoInternetConnection() {
        self.view.makeToast("nointernetConnection".localized())
    }
}

extension CreateAdVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: CreateAdCell.identifier, for: indexPath) as! CreateAdCell
        cell.countries = countries
        cell.categories = categories
        cell.adTypes = adTypes
        cell.farshLevels = farshLevels
        cell.currencies = currencies
        cell.additionalFacilities = additionalFacilities
        cell.cities = cities
        cell.selectionStyle = .none
        cell.delegate = self
        cell.initializeCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 120)
        for _ in additionalFacilities {
            height = height + UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 4)
        }
        return height
    }
}

extension CreateAdVC: CreateAdCellDelegate {
    func changeNumberOfBathrooms(newNumber: Int) {
        
    }
    
    func changeNumberOfRooms(newNumber: Int) {
        
    }
    
    func publishAd(ad: Ad, images: [Data]) {
        
    }
    
    func showCurrencies() {
        
    }
    
    func showCategories() {
        
    }
    
    func showAdTypes() {
        
    }
    
    func showCountries() {
        
    }
    
    func showCities() {
        
    }
    
    func showFarshLevels() {
        
    }
    
    func facilityChecked(checked: Bool, index: Int) {
        
    }
}
