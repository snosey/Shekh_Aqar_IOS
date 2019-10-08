//
//  AddressPickerPresenter.swift
//  Sheekhaqaar
//
//  Created by Hesham Donia on 5/13/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation

public protocol AddressPickerView: class {
    func getLocationsSuccess(addresses: [Address])
    func getLocationsFailed(errorMessage: String)
    func handleNoInternetConnection(message: String)
}

public class AddressPickerPresenter {
    fileprivate weak var addressPickerView : AddressPickerView?
    fileprivate let addressPickerRepository : AddressPickerRepository
    
    init(repository: AddressPickerRepository) {
        self.addressPickerRepository = repository
        self.addressPickerRepository.setDelegate(delegate: self)
    }
    
    // this initialize the presenter view methods
    func setView(view : AddressPickerView) {
        addressPickerView = view
    }
}

extension AddressPickerPresenter {
    func getLocationsByQuery(query: String) {
        if UiHelpers.isInternetAvailable() {
            addressPickerRepository.getLocationsByQuery(query: query)
        } else {
            self.addressPickerView?.handleNoInternetConnection(message: "noInternetConnection".localized())
        }
    }
}

extension AddressPickerPresenter: AddressPickerPresenterDelegate {
    public func getLocationsSuccess(addresses: [Address]) {
        UiHelpers.hideLoader()
        self.addressPickerView?.getLocationsSuccess(addresses: addresses)
    }
    
    public func getLocationsFailed(errorMessage: String) {
        UiHelpers.hideLoader()
        self.addressPickerView?.getLocationsFailed(errorMessage: errorMessage)
    }
}
