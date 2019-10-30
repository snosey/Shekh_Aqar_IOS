//
//  HomeVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/18/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import Localize_Swift
import GoogleMaps
import SideMenu
import SwiftyUserDefaults
import GooglePlaces

class HomeVC: BaseVC, UISideMenuNavigationControllerDelegate {

    public class func buildVC() -> HomeVC {
        let storyboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
    }
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var sideMenuIcon: UIImageView!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var showMapButton: LocalizedButton!
    @IBOutlet weak var showImagesButton: LocalizedButton!
    @IBOutlet weak var left1ImageView: UIImageView!
    @IBOutlet weak var left2ImageView: UIImageView!
    @IBOutlet weak var left3ImageView: UIImageView!
    @IBOutlet weak var right1ImageView: UIImageView!
    @IBOutlet weak var right2ImageView: UIImageView!
    @IBOutlet weak var right3ImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var collectionView3: UICollectionView!
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var googleEarthButton: UIButton!
    @IBOutlet weak var normalMapButton: UIButton!
    
    
    
    weak var sideMenuVC: SideMenuVC!
    var locationManager = CLLocationManager()
    var categories1 = [Category]()
    var categories2 = [Category]()
    var categories3 = [Category]()
    var alert: UIAlertController!
    
    var selectedIndex1 = 0
    var selectedIndex2 = 0
    var selectedIndex3 = 0
    
    var companies = [Company]()
    var ads = [Ad]()
    
    var selectedCategory: Category!
    var selectedCategoryPosition = 0
    var viewingMode = 1 // 1-->Map 2-->Table
    var alertController: UIAlertController!
    var presenter: HomePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GradientBG.createGradientLayer(view: topView, cornerRaduis: 0, maskToBounds: false)
        
        GradientBG.createGradientLayer(view: showMapButton, cornerRaduis: 4, maskToBounds: true)
        
        showImagesButton.layer.borderColor = UIColor.AppColors.textColor.cgColor
        showImagesButton.layer.borderWidth = 1
        showImagesButton.setTitleColor(UIColor.AppColors.textColor, for: .normal)
        
        searchIcon.addTapGesture { [weak self] (_) in
            self?.navigator.navigateToAddressPicker(delegate: self!)
        }
        
        showMapButton.addTapGesture { [weak self] (_) in
            
            if self?.viewingMode != 1 {
                GradientBG.createGradientLayer(view: self?.showMapButton ?? UIView(), cornerRaduis: 4, maskToBounds: true)
                self?.showMapButton.setTitleColor(UIColor.black, for: .normal)
                
                self?.showImagesButton.layer.sublayers?.remove(at: 0)
                self?.showImagesButton.layer.borderColor = UIColor.AppColors.textColor.cgColor
                self?.showImagesButton.layer.borderWidth = 1
                self?.showImagesButton.setTitleColor(UIColor.AppColors.textColor, for: .normal)
                
                self?.tableView.isHidden = true
                self?.googleMapView.isHidden = false
                
                self?.viewingMode = 1
                
                if let category = self?.selectedCategory {
                    if self?.selectedCategoryPosition == 1 {
                        self?.showCompaniesOnMap()
                    } else if self?.selectedCategoryPosition == 2 || self?.selectedCategoryPosition == 3 {
                        self?.presenter.getAds(subCategoryId: category.id, latitude: Singleton.getInstance().currentLatitude, longitude: Singleton.getInstance().currentLongitude)
                    }
                }
                
                self?.normalMapButton.isHidden = false
                self?.googleEarthButton.isHidden = false
            }
        }
        
        showImagesButton.addTapGesture { [weak self] (_) in
            if self?.viewingMode != 2 {
                GradientBG.createGradientLayer(view: self?.showImagesButton ?? UIView(), cornerRaduis: 4, maskToBounds: true)
                self?.showImagesButton.setTitleColor(UIColor.black, for: .normal)
                
                self?.showMapButton.layer.sublayers?.remove(at: 0)
                self?.showMapButton.layer.borderColor = UIColor.AppColors.textColor.cgColor
                self?.showMapButton.layer.borderWidth = 1
                self?.showMapButton.setTitleColor(UIColor.AppColors.textColor, for: .normal)
                
                self?.tableView.isHidden = false
                self?.googleMapView.isHidden = true
                
                self?.viewingMode = 2
                
                self?.tableView.reloadData()
                self?.normalMapButton.isHidden = true
                self?.googleEarthButton.isHidden = true
            }
        }
        
        changeArrows()
        
        setupScrollableViews()
        
        setupSideMenu()
        
        getCurrentLocation()
        
        presenter = Injector.provideHomePresenter()
        presenter.setView(view: self)
        presenter.getHomeCategories()
        
        if let _ = Defaults[.user] {
            presenter.getUserData()
        }
        
        if Singleton.getInstance().signUpData == nil {
            presenter.getSignUpData()
        }
    }
    
    func getCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 50
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func createMapView(latitude: Double, longitude: Double) {
        let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude), zoom: 12)
        googleMapView.camera = camera
        googleMapView.animate(to: camera)
        googleMapView.delegate = self
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
    }
    
    func showCompaniesOnMap() {
        googleMapView.clear()
        if companies.count > 0 {
            for company in companies {
                let marker = UiHelpers.addCompanyMarker(sourceView: self.view, latitude: Double(company.latitude)!, longitude: Double(company.longitude)!, title: company.name, secondLabelTitle: "\("adsNumber".localized()) \(company.numberOfAds!)", mapView: googleMapView, companyMarkerColor: "#eede71")
                marker.userData = company
            }
        } else {
            self.view.makeToast("noCompaniesInThisArea".localized())
        }
        
    }
    
    func showAdsOnMap() {
        googleMapView.clear()
        if ads.count > 0 {
            for ad in ads {
                let marker = UiHelpers.addCompanyMarker(sourceView: self.view, latitude: Double(ad.latitude)!, longitude: Double(ad.longitude)!, title: ad.name, secondLabelTitle: "\("price:".localized()) \(ad.price!) \(ad.currency.name!)", mapView: googleMapView, companyMarkerColor: ad.subCategory.hexCode ?? "#eede71")
                marker.userData = ad
            }
        } else {
             self.view.makeToast("noAdsInThisArea".localized())
        }
        
    }
    
    private func changeArrows() {
        if Localize.currentLanguage() == "ar" {
            left1ImageView.image = UIImage(named: "right_arrow")
            left2ImageView.image = UIImage(named: "right_arrow")
            left3ImageView.image = UIImage(named: "right_arrow")
            right1ImageView.image = UIImage(named: "left_arrow")
            right2ImageView.image = UIImage(named: "left_arrow")
            right3ImageView.image = UIImage(named: "left_arrow")
        }
    }
    
    private func setupSideMenu() {
        sideMenuIcon.addTapGesture { [weak self] (_) in
            if Localize.currentLanguage() == "en" {
                self?.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
            } else {
                self?.present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
            }
        }
        
        sideMenuVC = UiHelpers.setupSideMenu(delegate: self, viewToPresent: sideMenuIcon, viewToEdge: self.view, sideMenuCellDelegate: self, sideMenuHeaderDelegate: nil)
    }
    
    private func setupScrollableViews() {
        collectionView1.dataSource = self
        collectionView1.delegate = self
        if let layout = collectionView1.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        collectionView2.dataSource = self
        collectionView2.delegate = self
        if let layout = collectionView2.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: UiHelpers.getLengthAccordingTo(relation: .SCREEN_WIDTH
                , relativeView: nil, percentage: 100), height: UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 10))
        }
        
        collectionView3.dataSource = self
        collectionView3.delegate = self
        if let layout = collectionView3.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: UiHelpers.getLengthAccordingTo(relation: .SCREEN_WIDTH
                , relativeView: nil, percentage: 100), height: UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 10))
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func googleEarthClicked(_ sender: Any) {
        googleMapView.mapType = .satellite
    }
    
    @IBAction func googleMapsClicked(_ sender: Any) {
        googleMapView.mapType = .normal
    }
    
}

extension HomeVC: LocationSelectionDelegate {
    func locationSelected(address: Address) {
        Singleton.getInstance().currentLatitude = address.latitude
        Singleton.getInstance().currentLongitude = address.longitude
        createMapView(latitude: Singleton.getInstance().currentLatitude, longitude: Singleton.getInstance().currentLongitude)
        if let _ = selectedCategory {
            if self.selectedCategoryPosition == 2 || self.selectedCategoryPosition == 3 {
                self.presenter.getAds(subCategoryId: selectedCategory.id, latitude: Singleton.getInstance().currentLatitude, longitude: Singleton.getInstance().currentLongitude)
            } else {
                if selectedCategory.id == -4 {
                    presenter.getAds(latitude: Singleton.getInstance().currentLatitude, longitude: Singleton.getInstance().currentLongitude)
                } else {
                    presenter.getCompanies(categoryId: selectedCategory.id, latitude: Singleton.getInstance().currentLatitude, longitude: Singleton.getInstance().currentLongitude)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

extension HomeVC: HomeView {
    func showDownloadingAlert() {
        alert = UiHelpers.createAlertView(title: "downloading".localized(), message: "downloadingMessage".localized(), actions: [UIAlertAction(title: "ok".localized(), style: .default
            , handler: { (_) in
                self.alert.dismissVC(completion: nil)
        })])
        presentVC(alert)
    }
    
    func hideDownloadingAlert() {
        self.alert.dismissVC(completion: nil)
    }
    
    
    func getCompaniesSuccess(companies: [Company]) {
        self.companies = companies
        if viewingMode == 1 {
            showCompaniesOnMap()
        } else {
            tableView.reloadData()
        }
    }
    
    func getAdsSuccess(ads: [Ad]) {
        self.ads = ads
        if viewingMode == 1 {
            showAdsOnMap()
        } else {
            tableView.reloadData()
        }
    }
    
    func loginSuccess(user: User?, isExist: Bool) {
        if isExist {
            Defaults[.user] = user?.toJSON()
        }
    }
    
    func getCategoriesSuccess(firstRowCategories: [Category], secondRowCategories: [Category], thirdRowCategories: [Category]) {
        
        categories1 = firstRowCategories
        collectionView1.reloadData()
        
        categories2 = secondRowCategories
        collectionView2.reloadData()
        
        categories3 = thirdRowCategories
        collectionView3.reloadData()
    }
    
    func failed(errorMessage: String) {
        self.view.makeToast(errorMessage)
    }
    
    func handleNoInternetConnection() {
        self.view.makeToast("noInternetConnection".localized())
    }
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            return categories1.count
        } else if collectionView == collectionView2 {
            return categories2.count
        } else if collectionView == collectionView3 {
            return categories3.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        if collectionView == collectionView1 {
            cell.category = self.categories1.get(indexPath.row)!
        } else if collectionView == collectionView2 {
            cell.category = self.categories2.get(indexPath.row)!
        } else if collectionView == collectionView3 {
            cell.category = self.categories3.get(indexPath.row)!
        }
        
        cell.populateData()
        
        
        cell.categoryNameButton.addTapGesture { [weak self](_) in
            if collectionView == self?.collectionView1 {
                
                switch cell.category.id {
                case -1:
                    if let _ = Defaults[.user] {
                        // go to add ad
                        self?.navigator.navigateToCreateAd()
                    } else {
                        self?.navigator.navigateToSignUp()
                    }
                    break
                    
                case -2:
                    if let _ = Defaults[.user] {
                        // go to add ad
                        self?.navigator.navigateToRequestBuilding()
                    } else {
                        self?.navigator.navigateToSignUp()
                    }
                    break
                    
                case -3:
                    if let _ = Defaults[.company] {
                        self?.view.makeToast("alreadyHaveCompany".localized())
                    } else {
                        self?.navigator.navigateToRegisterAsCompany()
                    }
                    
                    break
                    
                case -4:
                    self?.presenter.getAds(latitude: Singleton.getInstance().currentLatitude, longitude: Singleton.getInstance().currentLongitude)
                    let dummayCategory = Category()
                    dummayCategory.id = -4
                    self?.selectedCategory = dummayCategory
                    break
                    
                default:
                    self?.selectedCategory = cell.category
                    if self?.viewingMode == 1 {
                        self?.presenter.getCompanies(categoryId: cell.category.id, latitude: Singleton.getInstance().currentLatitude, longitude: Singleton.getInstance().currentLongitude)
                    } else if self?.viewingMode == 2 {
                        self?.presenter.getCompanies(categoryId: cell.category.id, latitude: Singleton.getInstance().currentLatitude ?? 0, longitude: Singleton.getInstance().currentLongitude ?? 0)
                    }
                    break
                }
                
                self?.selectedCategoryPosition = 1
                self?.categories1[self?.selectedIndex1 ?? 0].isClicked = false
                self?.categories1[indexPath.row].isClicked = true
                if let oldCell = self?.collectionView1.cellForItem(at: IndexPath(item: self?.selectedIndex1 ?? 0, section: 0)) as? CategoryCell {
                    oldCell.populateData()
                }
                
                cell.populateData()
                self?.selectedIndex1 = indexPath.row
                
                
                var indexPathes2 = [IndexPath]()
                var count2 = 0
                for category in self?.categories2 ?? [] {
                    category.isClicked = false
                    indexPathes2.append(IndexPath(item: count2, section: 0))
                    count2 = count2 + 1
                }
                self?.collectionView2.reloadItems(at: indexPathes2)

                var indexPathes3 = [IndexPath]()
                var count3 = 0
                for category in self?.categories3 ?? [] {
                    category.isClicked = false
                    indexPathes3.append(IndexPath(item: count3, section: 0))
                    count3 = count3 + 1
                }
                self?.collectionView3.reloadItems(at: indexPathes3)
                
            } else if collectionView == self?.collectionView2 {
                
                
                self?.selectedCategoryPosition = 2
                self?.selectedCategory = cell.category
                self?.categories2[self?.selectedIndex2 ?? 0].isClicked = false
                self?.categories2[indexPath.row].isClicked = true
                if let oldCell = self?.collectionView2.cellForItem(at: IndexPath(item: self?.selectedIndex2 ?? 0, section: 0)) as? CategoryCell {
                    oldCell.populateData()
                }
                
                cell.populateData()
                self?.selectedIndex2 = indexPath.row
    
                self?.presenter.getAds(subCategoryId: cell.category.id, latitude: Singleton.getInstance().currentLatitude, longitude: Singleton.getInstance().currentLongitude)
                
                var indexPathes2 = [IndexPath]()
                var count2 = 0
                for category in self?.categories1 ?? [] {
                    category.isClicked = false
                    indexPathes2.append(IndexPath(item: count2, section: 0))
                    count2 = count2 + 1
                }
                self?.collectionView1.reloadItems(at: indexPathes2)

                var indexPathes3 = [IndexPath]()
                var count3 = 0
                for category in self?.categories3 ?? [] {
                    category.isClicked = false
                    indexPathes3.append(IndexPath(item: count3, section: 0))
                    count3 = count3 + 1
                }
                self?.collectionView3.reloadItems(at: indexPathes3)
                
            } else if collectionView == self?.collectionView3 {
                
                self?.selectedCategoryPosition = 3
                self?.selectedCategory = cell.category
                self?.categories3[self?.selectedIndex3 ?? 0].isClicked = false
                self?.categories3[indexPath.row].isClicked = true
                if let oldCell = self?.collectionView3.cellForItem(at: IndexPath(item: self?.selectedIndex3 ?? 0, section: 0)) as? CategoryCell {
                    oldCell.populateData()
                }
                
                cell.populateData()
                self?.selectedIndex3 = indexPath.row
                
                self?.presenter.getAds(subCategoryId: cell.category.id, latitude: Singleton.getInstance().currentLatitude, longitude: Singleton.getInstance().currentLongitude)
                
                var indexPathes2 = [IndexPath]()
                var count2 = 0
                for category in self?.categories1 ?? [] {
                    category.isClicked = false
                    indexPathes2.append(IndexPath(item: count2, section: 0))
                    count2 = count2 + 1
                }
                self?.collectionView1.reloadItems(at: indexPathes2)
                
                var indexPathes3 = [IndexPath]()
                var count3 = 0
                for category in self?.categories2 ?? [] {
                    category.isClicked = false
                    indexPathes3.append(IndexPath(item: count3, section: 0))
                    count3 = count3 + 1
                }
                self?.collectionView2.reloadItems(at: indexPathes3)
            }
        }
        
        return cell
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedCategoryPosition == 1 {
            return companies.count
        } else if selectedCategoryPosition == 2 || selectedCategoryPosition == 3 {
            return ads.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.selectedCategoryPosition == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CompanyCell.identifier, for: indexPath) as! CompanyCell
            cell.company = companies.get(indexPath.row)
            cell.delegate = self
            cell.initializeCell()
            cell.populateData()
            cell.selectionStyle = .none
            cell.contentView.addTapGesture { [weak self] (_) in
                self?.navigator.navigateToCompany(company: self?.companies.get(indexPath.row) ?? Company())
            }
            return cell
        } else if selectedCategoryPosition == 2 || selectedCategoryPosition == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AdCell.identifier, for: indexPath) as! AdCell
            cell.ad = ads.get(indexPath.row)
            cell.populateData()
            cell.selectionStyle = .none
            cell.contentView.addTapGesture { [weak self] (_) in
                self?.navigator.navigateToAdDetails(ad: self?.ads.get(indexPath.row) ?? Ad())
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 13)
    }
}

extension HomeVC: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if Singleton.getInstance().currentLocation == nil || (Singleton.getInstance().currentLocation.coordinate.latitude != locations.last!.coordinate.latitude && Singleton.getInstance().currentLocation.coordinate.longitude != locations.last!.coordinate.longitude) {
            Singleton.getInstance().currentLocation = locations.last!
        }
        
        Singleton.getInstance().currentLatitude = locations.last!.coordinate.latitude
        Singleton.getInstance().currentLongitude = locations.last!.coordinate.longitude
        
        createMapView(latitude: (Singleton.getInstance().currentLocation?.coordinate.latitude)!, longitude: (Singleton.instance.currentLocation?.coordinate.longitude)!)
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

extension HomeVC: CompanyCellDelegate {
    func goToCompanyScreen(company: Company?) {
        if let company = company {
            navigator.navigateToCompany(company: company)
        }
    }
    
    func callCompanyClicked(phoneNumber: String) {
        let urlString = "telprompt://\(phoneNumber)"
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    func openMapsClicked(latitude: Double, longitude: Double) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
        UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
        } else {
            self.view.makeToast("downloadGoogleMaps".localized())
        }
    }
}

extension HomeVC: SideMenuCellDelegate {
    func sideMenuItemSelected(index: Int) {
        switch index {
        case 0:
            break
            
        case 1:
            
            if let _ = Defaults[.user] {
                if let _ = Defaults[.company] {
                    navigator.navigateToEditCompany()
                } else {
                    navigator.navigateToEditProfile()
                }
            } else {
                navigator.navigateToSignUp()
            }
            break
            
        case 2:

            if let _ = Defaults[.user] {
                // go to add ad
                navigator.navigateToMyAds()
            } else {
                navigator.navigateToSignUp()
            }
            break
            
        case sideMenuVC.menuStringsDataSource.count - 3:
            navigator.navigateToFavourites()
            break
            
        case sideMenuVC.menuStringsDataSource.count - 2:
            navigator.navigateToHelp()
            break
            
        case sideMenuVC.menuStringsDataSource.count - 1:
            Defaults[.user] = nil
            Defaults[.company] = nil
            Defaults[.isSkipped] = nil
            navigator.navigateToSignUp()
            break
        default:
            break
        }
        sideMenuVC.dismissVC(completion: nil)
    }
}

extension HomeVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let userData = marker.userData {
            if let company = userData as? Company {
                self.navigator.navigateToCompany(company: company)
            } else if let ad = userData as? Ad {
                self.navigator.navigateToAdDetails(ad: ad)
            }
        }
        return true
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        mapView.clear()
        Singleton.getInstance().currentLatitude = position.target.latitude
        Singleton.getInstance().currentLongitude = position.target.longitude
        if let _ = selectedCategory {
            if self.selectedCategoryPosition == 2 || self.selectedCategoryPosition == 3 {
                self.presenter.getAds(subCategoryId: selectedCategory.id, latitude: Singleton.getInstance().currentLatitude, longitude: Singleton.getInstance().currentLongitude, showLoader: false)
            } else {
                if selectedCategory.id == -4 {
                    presenter.getAds(latitude: Singleton.getInstance().currentLatitude, longitude: Singleton.getInstance().currentLongitude, showLoader: false)
                } else {
                    presenter.getCompanies(categoryId: selectedCategory.id, latitude: Singleton.getInstance().currentLatitude, longitude: Singleton.getInstance().currentLongitude, showLoader: false)
                }
            }
        }
    }
}

extension HomeVC {
    func getLongestCategoryNameCharactersCount(categories1: [Category], categories2: [Category], categories3: [Category]) -> Int {
        var length = 0
        if categories1.count > 0 {
            for category in categories1 {
                if category.name.count > length {
                    length = category.name.count
                }
            }
        }
        
        if categories2.count > 0 {
            for category in categories2 {
                if category.name.count > length {
                    length = category.name.count
                }
            }
        }
        
        if categories3.count > 0 {
            for category in categories2 {
                if category.name.count > length {
                    length = category.name.count
                }
            }
        }
        
        return length
    }
    
    func addSpacesToSmallCategoriesNames(length: Int, categories: [Category]) -> [Category] {
        if categories.count > 0 {
            for category in categories {
                if category.name.count < length {
                    for _ in category.name.count...length {
                        category.name = category.name + " "
                    }
                }
            }
        }
        
        return categories
    }
}
