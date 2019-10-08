//
//  AddressPickerVC.swift
//  Sheekhaqaar
//
//  Created by Hesham Donia on 5/12/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import Localize_Swift
import DeviceKit

public protocol LocationSelectionDelegate {
    func locationSelected(address: Address)
}

class AddressPickerVC: BaseVC {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    
    var searchResultLocations = [Address]()
    var savedLocations = [Address]()
    var recentLocations = [Address]()
    
    var presenter: AddressPickerPresenter!
    var delegate: LocationSelectionDelegate!
    
    
    public class func buildVC(delegate: LocationSelectionDelegate) -> AddressPickerVC {
        let storyboard = UIStoryboard(name: "AddressPickerStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddressPickerVC") as! AddressPickerVC
        vc.delegate = delegate
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backImageView.addTapGesture { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        if Localize.currentLanguage() == "ar" {
            backImageView.transform = CGAffineTransform(rotationAngle: .pi)
            searchTextField.textAlignment = .right
        }
        
        // solve top view issue
        if Device.current != Device.iPhoneX && Device.current != Device.iPhoneXS && Device.current != Device.iPhoneXSMax {
            topView.snp.remakeConstraints { (maker) in
                maker.leading.trailing.top.equalTo(self.view)
                maker.height.equalTo(UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 15))
            }
        }
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)),
                             for: .editingChanged)
        
        presenter = Injector.provideAddressPickerPresenter()
        presenter.setView(view: self)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.reloadData()
        
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if textField.text!.isEmpty {
            self.searchResultLocations.removeAll()
            tableView.reloadData()
        } else {
            self.presenter.getLocationsByQuery(query: textField.text!)
        }
    }
}

extension AddressPickerVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
        
        cell.address = searchResultLocations.get(indexPath.row)
        cell.delegate = self
        cell.index = indexPath.row
        cell.populateData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 10)
    }
    
}

extension AddressPickerVC: AddressCellDelegate {
    func itemClicked(index: Int) {
        
        let address = searchResultLocations.get(index)!
        self.delegate.locationSelected(address: address)
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddressPickerVC: AddressPickerView {
    func getLocationsSuccess(addresses: [Address]) {
        searchResultLocations.removeAll()
        searchResultLocations = addresses
        tableView.reloadData()
    }
    
    func getLocationsFailed(errorMessage: String) {
         self.view.makeToast(errorMessage)
    }
    
    func handleNoInternetConnection(message: String) {
        self.view.makeToast(message)
    }
}
