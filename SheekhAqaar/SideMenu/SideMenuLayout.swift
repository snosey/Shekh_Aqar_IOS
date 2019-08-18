//
//  SideMenuLayout.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/17/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import UIKit
import UICircularProgressRing

protocol SideMenuLayoutDelegate: class {
    func closeSideMenu()
}

protocol SideMenuHeaderDelegate: class {
    func headerClicked()
}

public class SideMenuLayout {
    
    var sideMenuLayoutDelegate: SideMenuLayoutDelegate!
    var sideMenuHeaderDelegate: SideMenuHeaderDelegate!
    var superview: UIView!
    
    init(superview: UIView, sideMenuLayoutDelegate: SideMenuLayoutDelegate) {
        self.superview = superview
        superview.backgroundColor = .white
        self.sideMenuLayoutDelegate = sideMenuLayoutDelegate
    }
    
    lazy var menuHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#7C037A")
        view.addTapGesture(action: { (recognizer) in
            self.sideMenuHeaderDelegate.headerClicked()
        })
        return view
    }()
    
    lazy var userProfilePicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 15)/2
        return imageView
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = AppFont.font(type: .Bold, size: 20)
        return label
    }()
    
    lazy var userPhoneLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#ffffff")?.withAlphaComponent(0.48)
        label.textAlignment = .center
        label.font = AppFont.font(type: .Regular, size: 20)
        return label
    }()
    
    lazy var menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.register(SideMenuCell.self, forCellReuseIdentifier: SideMenuCell.identifier)
        return tableView
    }()
    
    public func setupViews() {
        let views = [menuHeaderView, menuTableView, userProfilePicImageView, usernameLabel, userPhoneLabel]
        
        self.superview.addSubviews(views)
        
        self.menuHeaderView.addSubviews([userProfilePicImageView, usernameLabel, userPhoneLabel])
        
        self.menuHeaderView.snp.makeConstraints { (maker) in
            maker.leading.trailing.top.equalTo(superview)
            maker.height.equalTo(UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 40))
        }
        
        menuHeaderView.bringSubviewToFront(userProfilePicImageView)
        menuHeaderView.bringSubviewToFront(usernameLabel)
        menuHeaderView.bringSubviewToFront(userPhoneLabel)
        
        self.userProfilePicImageView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalTo(self.menuHeaderView)
            maker.width.height.equalTo(UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 15))
        }
        
        self.usernameLabel.snp.makeConstraints { maker in
            maker.height.equalTo(UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 3))
            maker.leading.trailing.equalTo(self.menuHeaderView)
            maker.top.equalTo(self.userProfilePicImageView.snp.bottom).offset(UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 2))
        }
        
        self.userPhoneLabel.snp.makeConstraints { maker in
            maker.height.equalTo(UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 3))
            maker.leading.trailing.equalTo(self.menuHeaderView)
            maker.top.equalTo(self.usernameLabel.snp.bottom).offset(UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 1))
        }
        
        self.menuTableView.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(self.superview)
            maker.top.equalTo(self.menuHeaderView.snp.bottom)
            maker.bottom.equalTo(self.superview.bottom)
        }
    }
    
}
