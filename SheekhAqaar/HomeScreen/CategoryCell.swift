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
        if Localize.currentLanguage() == "en"{
            categoryNameButton.setTitle(category.nameEn, for: .normal)
        } else {
            categoryNameButton.setTitle(category.nameAr, for: .normal)
        }
    }
    
    public func changeLabelToBeClicked() {
        GradientBG.createGradientLayer(view: categoryNameButton, cornerRaduis: 8, maskToBounds: true)
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
}
