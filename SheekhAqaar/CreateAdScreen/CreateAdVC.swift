//
//  CreateAdVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/30/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

class CreateAdVC: BaseVC {

    public class func buildVC() -> CreateAdVC {
        let storyboard = UIStoryboard(name: "CreateAdStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateAdVC") as! CreateAdVC
        return vc
    }
    
    @IBOutlet weak var createAdTableView: UITableView!
    @IBOutlet weak var backIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backIcon.addTapGesture { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        createAdTableView.delegate = self
        createAdTableView.dataSource = self
        createAdTableView.reloadData()
    }

}

extension CreateAdVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreateAdCell.identifier, for: indexPath) as! CreateAdCell
        cell.populateData()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 120)
    }
}
