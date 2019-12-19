//
//  AdVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/29/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import Localize_Swift
import SwiftyUserDefaults

class AdVC: BaseVC {
    
    public class func buildVC(ad: Ad) -> AdVC {
        let storyboard = UIStoryboard(name: "AdStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AdVC") as! AdVC
        vc.ad = ad
        return vc
    }
    
    
    @IBOutlet weak var photosPageIndicator: UIPageControl!
    @IBOutlet weak var adAboutLabel: UILabel!
    @IBOutlet weak var backIcon: UIImageView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var adNameLabel: UILabel!
    @IBOutlet weak var addToFavouritesButton: LocalizedButton!
    @IBOutlet weak var companyAndTimeLabel: UILabel!
    @IBOutlet weak var adDetailsTableView: UITableView!
    @IBOutlet weak var additionalFacilitiesTableView: UITableView!
    @IBOutlet weak var adPriceLabel: UILabel!
   
    @IBOutlet weak var ownerNameLabel: UILabel!
    
    var ad: Ad!
    var adDetails = [AdDetail]()
    var presenter: AdPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBorders()
        
        presenter = Injector.provideAdPresenter()
        presenter.setView(view: self)
        presenter.getAd(adId: ad.id)
    }
    
    private func setBorders() {
        addToFavouritesButton.layer.borderWidth = 1
        addToFavouritesButton.layer.borderColor = UIColor.AppColors.textColor.cgColor
        
        adPriceLabel.layer.borderWidth = 1
        adPriceLabel.layer.borderColor = UIColor.AppColors.textColor.cgColor
    }
    
    private func populateData() {
        
        backIcon.addTapGesture { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        if let user = User(json: Defaults[.user] ?? [:]), ad.userId == user.id {
            addToFavouritesButton.setTitle("editAd".localized(), for: .normal)
        } else {
            if self.ad.isFavourite {
                addToFavouritesButton.setTitle("removeFromFav".localized(), for: .normal)
            } else {
                addToFavouritesButton.setTitle("addToFav".localized(), for: .normal)
            }
        }
        
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        photosCollectionView.reloadData()
        if let layout = photosCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
//            layout.minimumInteritemSpacing = 16
//            layout.minimumLineSpacing = 16
            layout.itemSize = CGSize(width: photosCollectionView.bounds.size.width, height: UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 20))
        }
        
        photosPageIndicator.currentPage = ad.adImages.count - 1
        photosPageIndicator.numberOfPages = ad.adImages.count
        
        adNameLabel.text = ad.name
        adAboutLabel.text = ad.details
        let date = UiHelpers.convertStringToDate(string: ad.creationTime, dateFormat: "dd/MM/yyyy hh:mm a")
        companyAndTimeLabel.text = " | " + date.timeAgoDisplay()
        if let _ = ad.company.name {
            ownerNameLabel.text = ad.company.name
            ownerNameLabel.addTapGesture { (_) in
                self.navigator.navigateToCompany(company: self.ad.company)
            }
        } else {
            ownerNameLabel.text = ad.user.name
            ownerNameLabel.addTapGesture { (_) in
                self.navigator.navigateToEditProfile()
            }
        }
        
        
        
        adDetailsTableView.dataSource = self
        adDetailsTableView.delegate = self
        adDetailsTableView.reloadData()
        
        additionalFacilitiesTableView.dataSource = self
        additionalFacilitiesTableView.delegate = self
        additionalFacilitiesTableView.reloadData()
        
        adPriceLabel.text = String(ad.price) + " " + ad.currency.name!
        
    }
    
    @IBAction func addToFavouritesClicked(_ sender: Any) {
        
        if let userDic = Defaults[.user] {
            if let user = User(json: userDic), ad.userId == user.id {
                self.navigator.navigateToEditAd(ad: ad)
            } else {
                if self.ad.isFavourite {
                    presenter.removeFavouriteAd(ad: ad)
                } else {
                    presenter.saveFavouriteAd(ad: ad)
                }
                self.ad.isFavourite = !self.ad.isFavourite
            }
        } else {
            self.navigator.navigateToSignUp()
        }
        
        
    }
    
    @IBAction func makeCallClicked(_ sender: Any) {
        if let phoneNumber = ad.user.phoneNumber {
            UiHelpers.makeCall(phoneNumber: phoneNumber)
        } else if let phoneNumber = ad.company.phoneNumber {
             UiHelpers.makeCall(phoneNumber: phoneNumber)
        } else {
            self.view.makeToast("phoneNotAvailable".localized())
        }
    }

    @IBAction func openWhatsAppClicked(_ sender: Any) {
        if let phoneNumber = ad.user.phoneNumber {
            UiHelpers.openWahtsApp(view: self.view, phoneNumber: phoneNumber)
        } else if let phoneNumber = ad.company.phoneNumber {
            UiHelpers.openWahtsApp(view: self.view, phoneNumber: phoneNumber)
        } else {
            self.view.makeToast("phoneNotAvailable".localized())
        }
    }
    
    @IBAction func openMapsClicked(_ sender: Any) {
        var actionSheet: UIAlertController!
        
        let googleMapsAction = UIAlertAction(title: "googleMaps".localized(), style: .default) { (_) in
            UiHelpers.openGoogleMaps(latitude: Singleton.getInstance().currentLatitude, longitude: Singleton.getInstance().currentLongitude)
        }
        
        let appleMapsAction = UIAlertAction(title: "appleMaps".localized(), style: .default) { (_) in
            UiHelpers.openAppleMaps(latitude: Singleton.getInstance().currentLatitude, longitude: Singleton.getInstance().currentLongitude)
        }
        
        actionSheet = UiHelpers.showActionSheet(title: "".localized(), message: "".localized(), actions: [googleMapsAction, appleMapsAction])
        
        presentVC(actionSheet)
    }
}

extension AdVC: AdView {
    func getAdSuccess(ad: Ad) {
        self.ad = ad
        
        populateData()
        
        if ad.adImages.count == 0 {
            photosCollectionView.isHidden =  true
            addToFavouritesButton.snp.remakeConstraints { (maker) in
                maker.top.equalTo(photosCollectionView)
                maker.trailing.equalTo(self.view).offset(-8)
                maker.width.equalTo(UiHelpers.getLengthAccordingTo(relation: .SCREEN_WIDTH, relativeView: nil, percentage: 0.4))
                maker.height.equalTo(UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 0.05))
            }
        } else {
            photosCollectionView.isHidden = false
        }
    }
    
    func saveFavouriteAdSuccess() {
        self.view.makeToast("addedToFavSuccess".localized())
        addToFavouritesButton.setTitle("removeFromFav".localized(), for: .normal)
    }
    
    public func removeFavouriteAdSuccess() {
        self.view.makeToast("removedToFavSuccess".localized())
        addToFavouritesButton.setTitle("addToFav".localized(), for: .normal)
    }
    
    func failed(errorMessage: String) {
        self.view.makeToast(errorMessage)
        //, duration: 2) {
//            self.navigationController?.popViewController(animated: true)
//        }
    }
    
    func handleNoInternetConnection() {
        self.view.makeToast("noInternetConnection".localized())
    }
}

extension AdVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ad.adImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdPhotoCell
            .identifier, for: indexPath) as! AdPhotoCell
        cell.imageUrl = ad.adImages.get(indexPath.row)?.imageUrl
        cell.populateData()
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        
        photosPageIndicator.currentPage = ad.adImages.count - Int(pageIndex) - 1
    }
    
    func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
        if(photosPageIndicator.currentPage == 0) {
            //Change background color to toRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1
            //Change pageControl selected color to toRed: 103/255, toGreen: 58/255, toBlue: 183/255, fromAlpha: 0.2
            //Change pageControl unselected color to toRed: 255/255, toGreen: 255/255, toBlue: 255/255, fromAlpha: 1
            
            let pageUnselectedColor: UIColor = fade(fromRed: 255/255, fromGreen: 255/255, fromBlue: 255/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            photosPageIndicator.pageIndicatorTintColor = pageUnselectedColor
            
            
//            let bgColor: UIColor = fade(fromRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1, toRed: 255/255, toGreen: 255/255, toBlue: 255/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
//            slides[photosPageIndicator.currentPage].backgroundColor = bgColor
            
            let pageSelectedColor: UIColor = fade(fromRed: 81/255, fromGreen: 36/255, fromBlue: 152/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            photosPageIndicator.currentPageIndicatorTintColor = pageSelectedColor
        }
    }
    
    
    func fade(fromRed: CGFloat,
              fromGreen: CGFloat,
              fromBlue: CGFloat,
              fromAlpha: CGFloat,
              toRed: CGFloat,
              toGreen: CGFloat,
              toBlue: CGFloat,
              toAlpha: CGFloat,
              withPercentage percentage: CGFloat) -> UIColor {
        
        let red: CGFloat = (toRed - fromRed) * percentage + fromRed
        let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
        let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
        let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
        
        // return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
}

extension AdVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == adDetailsTableView {
            return ad.itemMainModelArray.count + 3
        } else if tableView == additionalFacilitiesTableView {
            if ad.additionalFacilities.count % 2 == 0 {
                return ad.additionalFacilities.count / 2
            } else {
                return ((ad.additionalFacilities.count - 1) / 2) + 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == adDetailsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: AdDetailsCell.identifier, for: indexPath) as! AdDetailsCell
            switch  indexPath.row {
            case 0:
                cell.populateFirst3Rows(title: "adType".localized(), value: ad.subCategory.name, image: UIImage(named: "building")!)
                break
                
            case 1:
                cell.populateFirst3Rows(title: "detailedLocation".localized(), value: ad.detailedAddress, image: UIImage(named: "location")!)
                break
                
            case 2:
                cell.populateFirst3Rows(title: "aream2".localized(), value: String(ad.placeArea ?? 0), image: UIImage(named: "m2")!)
                break
            
            default:
                cell.itemMainModel = ad.itemMainModelArray.get(indexPath.row - 3)
                cell.populateData()
                
                break
            }
            cell.selectionStyle = .none
            return cell
        } else if tableView == additionalFacilitiesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: AdditionalFacilityCell.identifier, for: indexPath) as! AdditionalFacilityCell
            if ad.additionalFacilities.count % 2 == 0 {
                if indexPath.row == 0 {
                    cell.additionalFacility1 = ad.additionalFacilities.get(indexPath.row)
                    cell.additionalFacility2 = ad.additionalFacilities.get(indexPath.row + 1)
                } else {
                    cell.additionalFacility1 = ad.additionalFacilities.get(indexPath.row + 1)
                    cell.additionalFacility2 = ad.additionalFacilities.get(indexPath.row + 2)
                }
            } else {
                if indexPath.row == 0 {
                    cell.additionalFacility1 = ad.additionalFacilities.get(indexPath.row)
                    cell.additionalFacility2 = ad.additionalFacilities.get(indexPath.row + 1)
                } else if indexPath.row == (((ad.additionalFacilities.count - 1) / 2) + 1) - 1 {
                    cell.additionalFacility1 = ad.additionalFacilities.get(indexPath.row + 1)
                    cell.additionalFacility2 = nil
                } else {
                    cell.additionalFacility1 = ad.additionalFacilities.get(indexPath.row + 1)
                    cell.additionalFacility2 = ad.additionalFacilities.get(indexPath.row + 2)
                }
            }
            
            cell.populateData()
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 30) / 6
    }
}
