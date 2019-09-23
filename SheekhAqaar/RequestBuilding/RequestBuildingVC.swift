//
//  RequestBuildingVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/20/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

class RequestBuildingVC: BaseVC {
    @IBOutlet weak var backIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    public class func buildVC() -> RequestBuildingVC {
        let storyboard = UIStoryboard(name: "RequestBuildingStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RequestBuildingVC") as! RequestBuildingVC
        return vc
    }
    
    var cell: RequestBuildingCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backIcon.addTapGesture { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension RequestBuildingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: RequestBuildingCell.identifier, for: indexPath) as! RequestBuildingCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 120)
//        for _ in additionalFacilities {
//            height = height + UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 4)
//        }
        return height
    }
}
