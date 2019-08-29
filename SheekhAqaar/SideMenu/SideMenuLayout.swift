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
    
//    lazy var menuHeaderView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(hexString: "#7C037A")
//        view.addTapGesture(action: { (recognizer) in
//            self.sideMenuHeaderDelegate.headerClicked()
//        })
//        return view
//    }()
    
    lazy var appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 15)/2
        imageView.image = UIImage(named: "splash_icon")
        return imageView
    }()
    
//    lazy var usernameLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .white
//        label.textAlignment = .center
//        label.font = AppFont.font(type: .Bold, size: 20)
//        return label
//    }()
//
//    lazy var userPhoneLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor(hexString: "#ffffff")?.withAlphaComponent(0.48)
//        label.textAlignment = .center
//        label.font = AppFont.font(type: .Regular, size: 20)
//        return label
//    }()
    
    lazy var menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.register(SideMenuCell.self, forCellReuseIdentifier: SideMenuCell.identifier)
        return tableView
    }()
    
    public func setupViews() {
        let views = [menuTableView, appIconImageView]
        
        self.superview.addSubviews(views)
        
        
        self.appIconImageView.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.superview)
            maker.width.height.equalTo(UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 15))
            maker.top.equalTo(self.superview).offset(64)
        }
        
        self.menuTableView.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(self.superview)
            maker.top.equalTo(self.appIconImageView.snp.bottom).offset(8)
            maker.bottom.equalTo(self.superview.bottom)
        }
    }
    
}
