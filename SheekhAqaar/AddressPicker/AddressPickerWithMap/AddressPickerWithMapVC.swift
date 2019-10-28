//
//  AddressPickerWithMapVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 10/13/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import Localize_Swift
import DeviceKit
import GoogleMaps

class AddressPickerWithMapVC: BaseVC {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    
    var searchResultLocations = [Address]()
    var savedLocations = [Address]()
    var recentLocations = [Address]()
    
    var presenter: AddressPickerPresenter!
    var delegate: LocationSelectionDelegate!
    
    var selectedAddress: Address?
    var isFirstLoadingDone = false
    
    public class func buildVC(delegate: LocationSelectionDelegate) -> AddressPickerWithMapVC {
        let storyboard = UIStoryboard(name: "AddressPickerStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddressPickerWithMapVC") as! AddressPickerWithMapVC
        vc.delegate = delegate
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backImageView.addTapGesture { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        createMapView(latitude: Singleton.getInstance().currentLatitude, longitude: Singleton.getInstance().currentLongitude)
        
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
    
    func createMapView(latitude: Double, longitude: Double, zoomLeve: Float = 12) {
        let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude), zoom: zoomLeve)
        mapView.camera = camera
        mapView.animate(to: camera)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }

    @IBAction func confirmButtonClicked(_ sender: Any) {
        if let selectedAddress = selectedAddress {
            self.delegate.locationSelected(address: selectedAddress)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func normalMapClicked(_ sender: Any) {
        mapView.mapType = .normal
    }
    
    @IBAction func googleEarthClicked(_ sender: Any) {
        mapView.mapType = .satellite
    }
}

extension AddressPickerWithMapVC: UITableViewDataSource, UITableViewDelegate {
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

extension AddressPickerWithMapVC: AddressCellDelegate {
    func itemClicked(index: Int) {
        let address = searchResultLocations.get(index)!
        mapView.clear()
        createMapView(latitude: address.latitude, longitude: address.longitude)
        UiHelpers.addMarker(latitude: address.latitude, longitude: address.longitude, title: "", markerView: nil, mapView: mapView)
        selectedAddress = Address(addressId: address.addressId, addressName: address.addressName, addressCityName: address.addressCityName, latitude: address.latitude, longitude: address.longitude)
    }
}

extension AddressPickerWithMapVC: AddressPickerView {
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

extension AddressPickerWithMapVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        mapView.clear()
        createMapView(latitude: position.target.latitude, longitude: position.target.longitude, zoomLeve: mapView.camera.zoom)
        UiHelpers.addMarker(latitude: position.target.latitude, longitude: position.target.longitude, title: "", markerView: nil, mapView: mapView)
        
        self.selectedAddress = Address(addressId: "", addressName: "\(position.target.latitude), \(position.target.longitude)", addressCityName: "\(position.target.latitude), \(position.target.longitude)", latitude: position.target.latitude, longitude: position.target.longitude)
    }
}
