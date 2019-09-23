//
//  Injector.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/17/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation

public class Injector {
    
    public class func provideSignUpPresenter() -> SignUpPresenter {
        return SignUpPresenter(repository: Injector.provideSignUpRepository())
    }
    
    public class func provideSignUpRepository() -> SignUpRepository {
        return SignUpRepository()
    }
    
    public class func provideSignUp1Presenter() -> SignUp1Presenter {
        return SignUp1Presenter(repository: Injector.provideSignUp1Repository())
    }
    
    public class func provideSignUp1Repository() -> SignUp1Repository {
        return SignUp1Repository()
    }
    
    public class func providePhoneVerificationPresenter() -> PhoneVerificationPresenter {
        return PhoneVerificationPresenter(repository: Injector.providePhoneVerificationRepository())
    }
    
    public class func providePhoneVerificationRepository() -> PhoneVerificationRepository {
        return PhoneVerificationRepository()
    }
    
    public class func provideRegisterCompanyPresenter() -> RegisterCompanyPresenter {
        return RegisterCompanyPresenter(repository: Injector.provideRegisterCompanyRepository())
    }
    
    public class func provideRegisterCompanyRepository() -> RegisterCompanyRepository {
        return RegisterCompanyRepository()
    }
    
    public class func provideHomePresenter() -> HomePresenter {
        return HomePresenter(repository: Injector.provideHomeRepository())
    }
    
    public class func provideHomeRepository() -> HomeRepository {
        return HomeRepository()
    }
    
    public class func provideCompanyPresenter() -> CompanyPresenter {
        return CompanyPresenter(repository: Injector.provideCompanyRepository())
    }
    
    public class func provideCompanyRepository() -> CompanyRepository {
        return CompanyRepository()
    }
    
    public class func provideAdPresenter() -> AdPresenter {
        return AdPresenter(repository: Injector.provideAdRepository())
    }
    
    public class func provideAdRepository() -> AdRepository {
        return AdRepository()
    }
    
    public class func provideFavouritesPresenter() -> FavouritesPresenter {
        return FavouritesPresenter(repository: Injector.provideFavouritesRepository())
    }
    
    public class func provideFavouritesRepository() -> FavouritesRepository {
        return FavouritesRepository()
    }
    
    public class func provideCreateAdPresenter() -> CreateAdPresenter {
        return CreateAdPresenter(repository: Injector.provideCreateAdRepository())
    }
    
    public class func provideCreateAdRepository() -> CreateAdRepository {
        return CreateAdRepository()
    }
    
    public class func provideHelpPresenter() -> HelpPresenter {
        return HelpPresenter(repository: provideHelpRepository())
    }
    
    public class func provideHelpRepository() -> HelpRepository {
        return HelpRepository()
    }
}
