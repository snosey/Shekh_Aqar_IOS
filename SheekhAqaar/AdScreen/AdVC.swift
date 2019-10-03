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
        
        if let user = User(json: Defaults[.user]!), ad.userId == user.id {
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
        if let layout = photosCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.itemSize = CGSize(width: UiHelpers.getLengthAccordingTo(relation: .SCREEN_WIDTH
                , relativeView: nil, percentage: 80), height: UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 20))
        }
        
        adNameLabel.text = ad.name
        let date = UiHelpers.convertStringToDate(string: ad.creationTime, dateFormat: "dd/MM/yyyy hh:mm a")
        if let _ = ad.company.name {
            companyAndTimeLabel.text = ad.company.name + " | " + date.timeAgoDisplay()
        } else {
            companyAndTimeLabel.text = date.timeAgoDisplay()
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
        if let user = User(json: Defaults[.user]!), ad.userId == user.id {
            self.navigator.navigateToEditAd(ad: ad)
        } else {
            if self.ad.isFavourite {
                presenter.removeFavouriteAd(ad: ad)
            } else {
                presenter.saveFavouriteAd(ad: ad)
            }
            self.ad.isFavourite = !self.ad.isFavourite
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
}

extension AdVC: AdView {
    func getAdSuccess(ad: Ad) {
        self.ad = ad
        
        populateData()
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
    
    
}

extension AdVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == adDetailsTableView {
            return ad.itemMainModelArray.count
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
            cell.itemMainModel = ad.itemMainModelArray.get(indexPath.row)
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
