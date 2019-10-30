//
//  CategoryCell.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/24/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import Localize_Swift

class CategoryCell: UICollectionViewCell {
    public static let identifier = "CategoryCell"
    
    @IBOutlet weak var categoryNameButton: UIButton!
    
    public var category: Category!
    
    public func populateData() {
        changeLabelToBeUnclicked()
        
        if category.isClicked {
            changeLabelToBeClicked()
        }
        categoryNameButton.setTitle(category.name, for: .normal)
        categoryNameButton.titleLabel?.textAlignment = .center
        categoryNameButton.titleLabel?.adjustsFontSizeToFitWidth = false
        categoryNameButton.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    public func changeLabelToBeClicked() {
        GradientBG.createGradientLayer(view: categoryNameButton, cornerRaduis: 4, maskToBounds: true, size: CGSize(width: 120, height: 30))
        categoryNameButton.setTitleColor(.black, for: .normal)
    }
    
    public func changeLabelToBeUnclicked() {
        if let firstLayer = categoryNameButton.layer.sublayers?[0], firstLayer is CAGradientLayer {
            categoryNameButton.layer.sublayers?.remove(at: 0)
        }
        
        categoryNameButton.layer.borderColor = UIColor.AppColors.textColor.cgColor
        categoryNameButton.layer.borderWidth = 1
        categoryNameButton.setTitleColor(UIColor.AppColors.textColor, for: .normal)
    }
    
    override func prepareForReuse() {
        categoryNameButton.setTitle("", for: .normal)
        changeLabelToBeUnclicked()
    }
}
