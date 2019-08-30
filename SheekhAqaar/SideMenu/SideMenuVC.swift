//
//  SideMenuVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/17/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults
import AlamofireImage
import SnapKit
import SwiftyUserDefaults


class SideMenuVC : BaseVC {
    
    var layout: SideMenuLayout!
    var sideMenuCellDelegate: SideMenuCellDelegate!
    var sideMenuHeaderDelegate: SideMenuHeaderDelegate!
    
    var menuStringsDataSource: [String] = ["homeScreen".localized(), "editProfile".localized(), "tripHistory".localized(), "favourites".localized(), "help".localized()]
    
    
    static func buildVC() -> SideMenuVC {
        return SideMenuVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout = SideMenuLayout(superview: self.view, sideMenuLayoutDelegate: self)
        layout.setupViews()
        layout.sideMenuHeaderDelegate = self.sideMenuHeaderDelegate
        
        if let _ = Defaults[.user] {
            menuStringsDataSource.append("logout".localized())
        } else {
            menuStringsDataSource.append("login".localized())
        }
        
        setupMenuTableView()
        
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        showUserData()
    }
    
    func setupMenuTableView() {
        layout.menuTableView.dataSource = self
        layout.menuTableView.delegate = self
        layout.menuTableView.contentInset.top = 20
        layout.menuTableView.reloadData()
    }
    
//    func showUserData() {
        
//        layout.usernameLabel.text = DataHandler.shared.loggedUser()?.name
//        layout.userPhoneLabel.text = DataHandler.shared.loggedUser()?.mobile
//        if let imageUrl = DataHandler.shared.loggedUser()!.img, !imageUrl.isEmpty {
//            layout.userProfilePicImageView.af_setImage(withURL: URL(string: imageUrl)!, placeholderImage: UIImage(named: "background"))
//        }
//    }
}

extension SideMenuVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuStringsDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = SideMenuCell()
        cell.selectionStyle = .none
        cell.delegate = self.sideMenuCellDelegate
        cell.index = indexPath.row
        cell.backgroundColor = .clear
        cell.populateMenuItemData(data: self.menuStringsDataSource.get(at: indexPath.row)!)
        if indexPath.row == self.menuStringsDataSource.count - 1 {
            cell.lineView.isHidden = true
        } else {
            cell.lineView.isHidden = false
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableviewHeight = UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 40)
        return tableviewHeight / CGFloat(menuStringsDataSource.count)
    }
}

extension SideMenuVC: SideMenuLayoutDelegate {
    func retry() {
        
    }
    
    func closeSideMenu() {
        dismiss(animated: true, completion: nil)
    }
}
