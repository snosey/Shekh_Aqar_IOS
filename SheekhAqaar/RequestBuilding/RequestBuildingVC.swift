//
//  RequestBuildingVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/28/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

class RequestBuildingVC: BaseVC {

    public class func buildVC() -> RequestBuildingVC {
        let storyboard = UIStoryboard(name: "RequestBuildingStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RequestBuildingVC") as! RequestBuildingVC
        return vc
    }
    
    @IBOutlet weak var backIcon: UIImageView!
    @IBOutlet weak var adDataTableView: UITableView!
    
    var countries = Singleton.getInstance().signUpData.countries
    var selectedCountry: Country!
    
    var categories = Singleton.getInstance().mainCategories
    var selectedCategory: Category!
    
    var adTypes = [Category]()
    var selectedAdType: Category!
    
    var adDetailsItems = [AdDetailsItem]()
    
    var currencies = [Currency]()
    var selectedCurrency: Currency!
    
    var additionalFacilities = [AdditionalFacility]()
    var selectedAddtionalFacilities: [AdditionalFacility] = [AdditionalFacility]()
    
    var regions = [Region]()
    var selectedRegion: Region!
    
    var selectedLatitude: Double!
    var selectedLongitude: Double!
    
    var cell: RequestBuildingCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backIcon.addTapGesture { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        adDataTableView.delegate = self
        adDataTableView.dataSource = self
    }

}

extension RequestBuildingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: RequestBuildingCell.identifier, for: indexPath) as! RequestBuildingCell
        cell.selectionStyle = .none
//        cell.delegate = self
//        cell.initializeCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 80)
        for _ in additionalFacilities {
            height = height + UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 4)
        }
        for _ in adDetailsItems {
            height = height + UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 4)
        }
        return height
    }
}
