//
//  FavouritesVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/30/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

class FavouritesVC: BaseVC {

    public class func buildVC() -> FavouritesVC {
        let storyboard = UIStoryboard(name: "FavouritesStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesVC
        return vc
    }
    
    @IBOutlet weak var favouritesTableView: UITableView!
    @IBOutlet weak var backIcon: UIImageView!
    
    var presenter: FavouritesPresenter!
    var favourites = [Ad]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backIcon.addTapGesture { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        presenter = Injector.provideFavouritesPresenter()
        presenter.setView(view: self)
        presenter.getFavouriteAds()
    }

}

extension FavouritesVC: FavouritesView {
    func getFavouriteAdsSuccess(ads: [Ad]) {
        if ads.count > 0 {
            favourites = ads
            favouritesTableView.dataSource = self
            favouritesTableView.delegate = self
            favouritesTableView.reloadData()
        } else {
            self.view.makeToast("noDataAvailable".localized(), duration: 3) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    func failed(errorMessage: String) {
        self.view.makeToast(errorMessage)
    }
    
    func handleNoInternetConnection() {
        self.view.makeToast("noInternetConnection".localized())
    }
}

extension FavouritesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdCell.identifier, for: indexPath) as! AdCell
        cell.ad = favourites.get(indexPath.row)
        cell.populateData()
        cell.selectionStyle = .none
        cell.contentView.addTapGesture { [weak self] (_) in
            self?.navigator.navigateToAdDetails(ad: self?.favourites.get(indexPath.row) ?? Ad())
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 10)
    }
}
