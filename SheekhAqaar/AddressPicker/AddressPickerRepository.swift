//
//  AddressPickerRepository.swift
//  Sheekhaqaar
//
//  Created by Hesham Donia on 5/14/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Alamofire
import Localize_Swift

public protocol AddressPickerPresenterDelegate: class {
    func getLocationsSuccess(addresses: [Address])
    func getLocationsFailed(errorMessage: String)
}

public class AddressPickerRepository {
    var delegate: AddressPickerPresenterDelegate!
    var addresses = [Address]()
    var predictionsCount = 0
    
    public func setDelegate(delegate: AddressPickerPresenterDelegate) {
        self.delegate = delegate
    }
    
    public func getLocationsByQuery(query: String) {
        let input = query.replacingOccurrences(of: " ", with: "+")
        var parameters = ["input" : input,
                          "language" : Localize.currentLanguage(),
                          
                          "key" : CommonConstants.GOOGLE_MAPS_KEY] as [String : Any] //"types" : "geocode",
        //"components" : "country:eg",
        if Singleton.getInstance().currentLocation != nil {
            parameters["location"] = "\(Singleton.getInstance().currentLocation.coordinate.latitude),\(Singleton.getInstance().currentLocation.coordinate.longitude)"
            parameters["radius"] = 5000000000
            
            parameters["origin"] = "\(Singleton.getInstance().currentLocation.coordinate.latitude),\(Singleton.getInstance().currentLocation.coordinate.longitude)"
        }
        
        Alamofire.request("https://maps.googleapis.com/maps/api/place/autocomplete/json", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
            case .success(_):
                let json = (response.result.value as! Dictionary<String,AnyObject>)
                if let predictionsJsonArray = json["predictions"] as? [Dictionary<String,AnyObject>] {
                    self.predictionsCount = predictionsJsonArray.count
                    
                    for prediction in predictionsJsonArray {
                        let locationId = prediction["place_id"] as! String
                        self.getLocationDataById(locationId: locationId)
                    }
                    self.addresses.removeAll()
                } else if let errorMessage = json["error_message"] as? String {
                    self.delegate.getLocationsFailed(errorMessage: errorMessage)
                }
                break
                
            case .failure(let error):
                self.delegate.getLocationsFailed(errorMessage: error.localizedDescription)
                break
            }
        }
    }
    
    public func getLocationDataById(locationId: String) {
        let parameters = ["placeid" : locationId,
                          "language" : Localize.currentLanguage(),
                          "key" : CommonConstants.GOOGLE_MAPS_KEY] as [String : Any]
        
        Alamofire.request("https://maps.googleapis.com/maps/api/place/details/json", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
            case .success(_):
                let json = (response.result.value as! Dictionary<String,AnyObject>)
                if let resultObj = json["result"] as?  Dictionary<String,AnyObject> {
                    let address = Address()
                    address.addressId = locationId
                    address.addressName = resultObj["formatted_address"] as? String
                    address.addressCityName = resultObj["name"] as? String
                    if let geometry = resultObj["geometry"] as? Dictionary<String,AnyObject> {
                        if let location = geometry["location"] as? Dictionary<String,AnyObject> {
                            if let lat = location["lat"] as? Double {
                                address.latitude = lat
                            }
                            
                            if let lng = location["lng"] as? Double {
                                address.longitude = lng
                            }
                        }
                    }
                    self.addresses.append(address)
                    if self.addresses.count == self.predictionsCount {
                        self.delegate.getLocationsSuccess(addresses: self.addresses)
                    }
                }
                break
                
            case .failure(let error):
                self.delegate.getLocationsFailed(errorMessage: error.localizedDescription)
                break
            }
        }
        
        
    }
}
