//
//  AdDetailsWithSpinnerCellCell.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/23/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import DropDown

class AdDetailsWithSpinnerCell: UITableViewCell {

    public static let identifier = "AdDetailsWithSpinnerCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueView: UIView!
    @IBOutlet weak var valueLabel: UILabel!
 
    var adDetailsItem: AdDetailsItem!
    
    let dropDown = DropDown()
    
    public func populateData() {
        titleLabel.text = adDetailsItem.name
        if let value = adDetailsItem.value {
            valueLabel.text = adDetailsItem.spinnerDataArray.filter({ (item) -> Bool in
                return item.id == value
            })[0].name
        } else if valueLabel.text == "pleaseInsert".localized() + adDetailsItem.name || valueLabel.text?.isEmpty ?? true  {
            if #available(iOS 13.0, *) {
                valueLabel.textColor = .placeholderText
            } else {
                valueLabel.textColor = .lightGray
            }
            valueLabel.text = "pleaseInsert".localized() + adDetailsItem.name
        }
        
        valueView.addTapGesture { [weak self] (_) in
            if self?.adDetailsItem.spinnerDataArray.count ?? 0 > 0 {
                self?.dropDown.anchorView = self?.valueView
                var dataSource = [String]()
                for spinnerDataItem in self?.adDetailsItem.spinnerDataArray ?? [] {
                    dataSource.append(spinnerDataItem.name)
                }
                
                self?.dropDown.dataSource = dataSource
                self?.dropDown.selectionAction = { [weak self] (index: Int, item: String) in
                    self?.valueLabel.text = item
                    self?.valueLabel.textColor = .black
                }
                self?.dropDown.direction = .any
                self?.dropDown.show()
            } else {
                self?.contentView.makeToast("noData".localized())
            }
        }
    }
    
    
}
