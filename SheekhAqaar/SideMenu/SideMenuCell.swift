//
//  SideMenuCell.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/17/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import UIKit


public protocol SideMenuCellDelegate : class {
    func sideMenuItemSelected(index: Int)
}

class SideMenuCell: UITableViewCell {
    
    public static let identifier = "SideMenuCell"
    public var index: Int!
    public var delegate: SideMenuCellDelegate!
    
    lazy var menuItemLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        lbl.font = AppFont.font(type: .Regular, size: 15)
        return lbl
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.AppColors.darkTextColor
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func setup() {
        let superView = self.contentView
        superView.backgroundColor = .clear
        superView.addSubviews([menuItemLabel, lineView])
        superView.addTapGesture { (recognizer) in
            self.delegate.sideMenuItemSelected(index: self.index)
        }
        
        self.menuItemLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(superView).offset(15)
            maker.top.equalTo(superView).offset(10)
            maker.trailing.equalTo(superView).offset(-15)
            maker.bottom.equalTo(superView).offset(-10)
        }
        
        self.lineView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(superView)
            maker.height.equalTo(1)
            maker.centerX.equalTo(superView)
            maker.width.equalTo(UiHelpers.getLengthAccordingTo(relation: .VIEW_WIDTH, relativeView: superView, percentage: 70))
        }
    }
    
    func populateMenuItemData(data: String) {
        self.menuItemLabel.text = data
    }
}
