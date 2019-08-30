//
//  AdVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/29/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import Localize_Swift

class AdVC: BaseVC {
    
    public class func buildVC(ad: Ad) -> AdVC {
        let storyboard = UIStoryboard(name: "AdStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AdVC") as! AdVC
        vc.ad = ad
        vc.adDetails.append(AdDetail(title: "adType".localized(), details: ad.adType.nameEn, imageName: "building"))
        vc.adDetails.append(AdDetail(title: "location".localized(), details: ad.detailedAddress, imageName: "location"))
        vc.adDetails.append(AdDetail(title: "area".localized(), details: String(ad.placeArea) + "meter".localized(), imageName: "m2"))
        vc.adDetails.append(AdDetail(title: "roomsCount".localized(), details: String(ad.roomsNumber), imageName: "bed"))
        vc.adDetails.append(AdDetail(title: "bathroomsCount".localized(), details: String(ad.bathRoomsNumber), imageName: "bathroom"))
        vc.adDetails.append(AdDetail(title: "farsh".localized(), details: ad.farshLevel.nameEn, imageName: "farsh"))
        return vc
    }
    
    
    @IBOutlet weak var backIcon: UIImageView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var adNameLabel: UILabel!
    @IBOutlet weak var addToFavouritesButton: LocalizedButton!
    @IBOutlet weak var companyAndTimeLabel: UILabel!
    @IBOutlet weak var adDetailsTableView: UITableView!
    @IBOutlet weak var additionalFacilitiesTableView: UITableView!
    @IBOutlet weak var adPriceLabel: UILabel!
   
    
    var ad: Ad!
    var adDetails = [AdDetail]()
    var presenter: AdPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBorders()
        
        populateData()
        
        presenter = Injector.provideAdPresenter()
        presenter.setView(view: self)
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
        
        if self.ad.isFavourite {
            addToFavouritesButton.setTitle("removeFromFav".localized(), for: .normal)
        } else {
            addToFavouritesButton.setTitle("addToFav".localized(), for: .normal)
        }
        
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        if let layout = photosCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.itemSize = CGSize(width: UiHelpers.getLengthAccordingTo(relation: .SCREEN_WIDTH
                , relativeView: nil, percentage: 80), height: UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 20))
        }
        
        adNameLabel.text = ad.name
        companyAndTimeLabel.text = ad.companyName + " | " + Date(milliseconds: Int(ad.creationTime) * 1000).timeAgoDisplay()
        
        adDetailsTableView.dataSource = self
        adDetailsTableView.delegate = self
        adDetailsTableView.reloadData()
        
        additionalFacilitiesTableView.dataSource = self
        additionalFacilitiesTableView.delegate = self
        additionalFacilitiesTableView.reloadData()
        
        if Localize.currentLanguage() == "ar" {
             adPriceLabel.text = String(ad.price) + " " + ad.currency.nameAr
        } else {
             adPriceLabel.text = String(ad.price) + " " + ad.currency.nameEn
        }
    }
    
    @IBAction func addToFavouritesClicked(_ sender: Any) {
        if self.ad.isFavourite {
            presenter.removeFavouriteAd(ad: ad)
        } else {
            presenter.saveFavouriteAd(ad: ad)
        }
        self.ad.isFavourite = !self.ad.isFavourite
    }
    
    @IBAction func makeCallClicked(_ sender: Any) {
        UiHelpers.makeCall(phoneNumber: ad.phoneNumber)
    }

}

extension AdVC: AdView {
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
    }
    
    func handleNoInternetConnection() {
        self.view.makeToast("noInternetConnection".localized())
    }
}

extension AdVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ad.imagesUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdPhotoCell
            .identifier, for: indexPath) as! AdPhotoCell
        cell.imageUrl = ad.imagesUrls.get(indexPath.row)
        cell.populateData()
        return cell
    }
    
    
}

extension AdVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == adDetailsTableView {
            return 6
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
            cell.adDetail = adDetails.get(indexPath.row)
            cell.populateData()
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
