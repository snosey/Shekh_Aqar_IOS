//
//  FavouritesVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/30/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

class MyAdsVC: BaseVC {

    public class func buildVC() -> MyAdsVC {
        let storyboard = UIStoryboard(name: "MyAdsStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MyAdsVC") as! MyAdsVC
        return vc
    }
    
    @IBOutlet weak var myAdsTableView: UITableView!
    @IBOutlet weak var backIcon: UIImageView!
    
    var presenter: MyAdsPresenter!
    var favourites = [Ad]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backIcon.addTapGesture { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        presenter = Injector.provideMyAdsPresenter()
        presenter.setView(view: self)
        presenter.getMyAds()
    }

}

extension MyAdsVC: MyAdsView {
    func getMyAdsSuccess(ads: [Ad]) {
        favourites = ads
        myAdsTableView.dataSource = self
        myAdsTableView.delegate = self
        myAdsTableView.reloadData()
    }
    
    func failed(errorMessage: String) {
        self.view.makeToast(errorMessage)
    }
    
    func handleNoInternetConnection() {
        self.view.makeToast("noInternetConnection".localized())
    }
}

extension MyAdsVC: UITableViewDataSource, UITableViewDelegate {
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
