//
//  CompanyVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/27/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import Localize_Swift

class CompanyVC: BaseVC {

    public class func buildVC(company: Company) -> CompanyVC {
        let storyboard = UIStoryboard(name: "CompanyStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CompanyVC") as! CompanyVC
        vc.company = company
        return vc
    }
    
    @IBOutlet weak var backIcon: UIImageView!
    @IBOutlet weak var companyPhotoImageView: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyNumberOfAdsLabel: UILabel!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var whatsAppView: UIView!
    @IBOutlet weak var adsTableView: UITableView!
    
    var company: Company!
    var presenter: CompanyPresenter!
    var ads = [Ad]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backIcon.addTapGesture { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        populateCompanyData()
        
        presenter = Injector.provideCompanyPresenter()
        presenter.setView(view: self)
        presenter.getCompanyAds(companyId: company.id)
        
    }
    
    private func populateCompanyData() {
        
        companyPhotoImageView.layer.cornerRadius = UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 10.5) / 2
        companyPhotoImageView.layer.masksToBounds = true
        
        if let url = URL(string: company.imageUrl) {
            companyPhotoImageView.af_setImage(withURL: url)
        }
        
        companyNameLabel.text = company.name
        
        companyNumberOfAdsLabel.text = "\("adsNumber".localized()) \(company.numberOfAds!)"
        
        addressView.addTapGesture { [weak self] (_) in
            UiHelpers.openGoogleMaps(latitude: Double(self?.company.latitude ?? "") ?? 0, longitude: Double(self?.company.longitude ?? "") ?? 0)
        }
        
        callView.addTapGesture { [weak self] (_) in
            UiHelpers.makeCall(phoneNumber: self?.company.phoneNumber ?? "")
        }
        
        whatsAppView.addTapGesture { [weak self](_) in
            UiHelpers.openWahtsApp(view: self?.view ?? UIView(), phoneNumber: self?.company.phoneNumber ?? "" )
        }
    }
}

extension CompanyVC: CompanyView {
    func getCompanyAdsSuccess(ads: [Ad]) {
        self.ads = ads
        adsTableView.dataSource = self
        adsTableView.delegate = self
        adsTableView.reloadData()
    }
    
    func failed(errorMessage: String) {
        self.view.makeToast(errorMessage)
    }
    
    func handleNoInternetConnection() {
        self.view.makeToast("noInternetConnection".localized())
    }
}

extension CompanyVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdCell.identifier, for: indexPath) as! AdCell
        cell.ad = ads.get(indexPath.row)
        cell.populateData()
        cell.selectionStyle = .none
        cell.contentView.addTapGesture { [weak self] (_) in
            self?.navigator.navigateToAdDetails(ad: self?.ads.get(indexPath.row) ?? Ad())
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 14)
    }
}
