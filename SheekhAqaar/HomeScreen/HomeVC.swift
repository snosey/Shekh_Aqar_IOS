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
    
    weak var sideMenuVC: SideMenuVC!
    var locationManager = CLLocationManager()
    var categories1 = [Category]()
    var categories2 = [Category]()
    var categories3 = [Category]()
    
    var selectedCategory: Category!
    var selectedCategoryPosition = 0
    var viewingMode = 1 // 1-->Map 2-->Table
    var alertController: UIAlertController!
    var presenter: HomePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GradientBG.createGradientLayer(view: topView, cornerRaduis: 0, maskToBounds: false)
        
        GradientBG.createGradientLayer(view: showMapButton, cornerRaduis: 8, maskToBounds: true)
        
        showImagesButton.layer.borderColor = UIColor.AppColors.textColor.cgColor
        showImagesButton.layer.borderWidth = 1
        showImagesButton.setTitleColor(UIColor.AppColors.textColor, for: .normal)
        
        showMapButton.addTapGesture { [weak self] (_) in
            GradientBG.createGradientLayer(view: self?.showMapButton ?? UIView(), cornerRaduis: 8, maskToBounds: true)
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
                    self?.showCompaniesOnMap(category: category)
                } else if self?.selectedCategoryPosition == 2 || self?.selectedCategoryPosition == 3 {
                    self?.showAdsOnMap(category: category)
                }
            }
        }
        
        showImagesButton.addTapGesture { [weak self] (_) in
            GradientBG.createGradientLayer(view: self?.showImagesButton ?? UIView(), cornerRaduis: 8, maskToBounds: true)
            self?.showImagesButton.setTitleColor(UIColor.black, for: .normal)
            
            self?.showMapButton.layer.sublayers?.remove(at: 0)
            self?.showMapButton.layer.borderColor = UIColor.AppColors.textColor.cgColor
            self?.showMapButton.layer.borderWidth = 1
            self?.showMapButton.setTitleColor(UIColor.AppColors.textColor, for: .normal)
            
            self?.tableView.isHidden = false
            self?.googleMapView.isHidden = true
            
            self?.viewingMode = 2
            
            self?.tableView.reloadData()
        }
        
        changeArrows()
        
        setupScrollableViews()
        
        setupSideMenu()
        
        getCurrentLocation()
        
        presenter = Injector.provideHomePresenter()
        presenter.setView(view: self)
        presenter.getFirstCategories()
        if let _ = Defaults[.user] {
            presenter.getUserData()
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
    
    func showCompaniesOnMap(category: Category) {
        googleMapView.clear()
        for company in category.companies {
            let marker = UiHelpers.addCompanyMarker(sourceView: self.view, latitude: company.latitude, longitude: company.longitude, title: company.nameEn, adsNumber: company.numberOfAds, mapView: googleMapView)
            marker.userData = company
        }
    }
    
    func showAdsOnMap(category: Category) {
        googleMapView.clear()
        for ad in category.ads {
           let marker = UiHelpers.addCompanyMarker(sourceView: self.view, latitude: ad.latitude, longitude: ad.longitude, title: ad.name, adsNumber: category.ads.count, mapView: googleMapView)
            marker.userData = ad
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
            layout.itemSize = CGSize(width: UiHelpers.getLengthAccordingTo(relation: .SCREEN_WIDTH
                , relativeView: nil, percentage: 100), height: UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 10))
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
                , relativeView: nil, percentage: 25), height: UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 10))
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension HomeVC: HomeView {
    func loginSuccess(user: User?, isExist: Bool) {
        if isExist {
            Defaults[.user] = user?.toJSON()
        }
    }
    
    func getFirstCategoriesSuccess(categories: [Category]) {
        categories1 = categories
        collectionView1.reloadData()
        presenter.getSecondCategories()
    }
    
    func getSecondCategoriesSuccess(categories: [Category]) {
        categories2 = categories
        collectionView2.reloadData()
        presenter.getThirdCategories()
    }
    
    func getThirdCategoriesSuccess(categories: [Category]) {
        categories3 = categories
        collectionView3.reloadData()
    }
    
    func failed(errorMessage: String) {
        self.view.makeToast(errorMessage)
    }
    
    func handleNoInternetConnection() {
        self.view.makeToast("noInternetConnection".localized())
    }
    
    
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate {
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
        cell.changeLabelToBeUnclicked()
        
        if cell.category.isClicked {
            cell.changeLabelToBeClicked()
        }
        
        cell.categoryNameButton.addTapGesture { [weak self](_) in
            if collectionView == self?.collectionView1 {
                self?.selectedCategoryPosition = 1
                self?.selectedCategory = cell.category
                if self?.viewingMode == 1 {
                    self?.showCompaniesOnMap(category: cell.category)
                } else if self?.viewingMode == 2 {
                    self?.tableView.reloadData()
                }
                
                var indexPathes1 = [IndexPath]()
                var count1 = 0
                for category in self?.categories1 ?? [] {
                    category.isClicked = false
                    indexPathes1.append(IndexPath(item: count1, section: 0))
                    count1 = count1 + 1
                }
                self?.categories1[indexPath.row].isClicked = true
                self?.collectionView1.reloadItems(at: indexPathes1)
                
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
                if self?.viewingMode == 1 {
                    self?.showAdsOnMap(category: cell.category)
                } else if self?.viewingMode == 2 {
                    self?.tableView.reloadData()
                }
                var indexPathes1 = [IndexPath]()
                var count1 = 0
                for category in self?.categories2 ?? [] {
                    category.isClicked = false
                    indexPathes1.append(IndexPath(item: count1, section: 0))
                    count1 = count1 + 1
                }
                self?.categories2[indexPath.row].isClicked = true
                self?.collectionView2.reloadItems(at: indexPathes1)
                
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
                if self?.viewingMode == 1 {
                    self?.showAdsOnMap(category: cell.category)
                } else if self?.viewingMode == 2 {
                    self?.tableView.reloadData()
                }
                var indexPathes1 = [IndexPath]()
                var count1 = 0
                for category in self?.categories3 ?? [] {
                    category.isClicked = false
                    indexPathes1.append(IndexPath(item: count1, section: 0))
                    count1 = count1 + 1
                }
                self?.categories3[indexPath.row].isClicked = true
                self?.collectionView3.reloadItems(at: indexPathes1)
                
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
            return selectedCategory.companies.count
        } else if selectedCategoryPosition == 2 || selectedCategoryPosition == 3 {
            return selectedCategory.ads.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.selectedCategoryPosition == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CompanyCell.identifier, for: indexPath) as! CompanyCell
            cell.company = self.selectedCategory.companies.get(indexPath.row)
            cell.delegate = self
            cell.initializeCell()
            cell.populateData()
            cell.selectionStyle = .none
            cell.contentView.addTapGesture { [weak self] (_) in
                self?.navigator.navigateToCompany(company: self?.selectedCategory.companies.get(indexPath.row) ?? Company())
            }
            return cell
        } else if selectedCategoryPosition == 2 || selectedCategoryPosition == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AdCell.identifier, for: indexPath) as! AdCell
            cell.ad = selectedCategory.ads.get(indexPath.row)
            cell.populateData()
            cell.selectionStyle = .none
            cell.contentView.addTapGesture { [weak self] (_) in
                self?.navigator.navigateToAdDetails(ad: self?.selectedCategory.ads.get(indexPath.row) ?? Ad())
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 15)
    }
}

extension HomeVC: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if Singleton.getInstance().currentLocation == nil || (Singleton.getInstance().currentLocation.coordinate.latitude != locations.last!.coordinate.latitude && Singleton.getInstance().currentLocation.coordinate.longitude != locations.last!.coordinate.longitude) {
            Singleton.getInstance().currentLocation = locations.last!
        }
        
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
                // go to edit profile
            } else {
                navigator.navigateToSignUp()
            }
            break
            
        case 2:
            
            if let _ = Defaults[.user] {
                // go to add ad
                navigator.navigateToCreateAd()
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
            if let _ = Defaults[.user] {
                Defaults.remove(.user)
            }
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
}
