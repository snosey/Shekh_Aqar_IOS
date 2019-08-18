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
        lbl.textColor = .black
        lbl.numberOfLines = 1
        lbl.font = AppFont.font(type: .Regular, size: 15)
        return lbl
    }()
    
    lazy var menuItemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        superView.addSubviews([menuItemLabel, menuItemImageView])
        superView.addTapGesture { (recognizer) in
            self.delegate.sideMenuItemSelected(index: self.index)
        }
        
        self.menuItemImageView.snp.makeConstraints { maker in
            maker.top.equalTo(superView).offset(15)
            maker.leading.equalTo(superView).offset(10)
            maker.width.equalTo(30)
            maker.bottom.equalTo(superView).offset(-15)
        }
        
        self.menuItemLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(menuItemImageView.snp.trailing).offset(10)
            maker.top.equalTo(superView).offset(10)
            maker.trailing.equalTo(superView).offset(-15)
            maker.bottom.equalTo(superView).offset(-10)
        }
    }
    
    func populateMenuItemData(data: String, image: UIImage) {
        self.menuItemLabel.text = data
        self.menuItemImageView.image = image
    }    
}
