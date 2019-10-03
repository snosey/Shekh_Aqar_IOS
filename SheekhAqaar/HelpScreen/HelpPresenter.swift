//
//  HelpPresenter.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/23/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation

public protocol HelpView: class {
    func getHelpDateSuccess(helpData: HelpData)
    func failed(errorMessage: String)
    func handleNoInternetConnection()
}

public class HelpPresenter {
    fileprivate weak var helpView : HelpView?
    fileprivate let helpRepository : HelpRepository?
    
    init(repository: HelpRepository) {
        self.helpRepository = repository
        self.helpRepository?.setDelegate(delegate: self)
    }
    
    // this initialize the presenter view methods
    func setView(view : HelpView) {
        helpView = view
    }
}

extension HelpPresenter {
    public func getHelpData() {
        if UiHelpers.isInternetAvailable() {
            UiHelpers.showLoader()
            helpRepository?.getHelpData()
        } else {
            helpView?.handleNoInternetConnection()
        }
    }
}

extension HelpPresenter: HelpPresenterDelegate {
    public func getHelpDateSuccess(helpData: HelpData) {
        UiHelpers.hideLoader()
        self.helpView?.getHelpDateSuccess(helpData: helpData)
    }
    
    public func failed(errorMessage: String) {
        UiHelpers.hideLoader()
        self.helpView?.failed(errorMessage: errorMessage)
    }
}
