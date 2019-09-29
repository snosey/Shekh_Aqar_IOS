//
//  Ad.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/26/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import Gloss

public class Ad: DataType {
    
    var id: Int!
    var name : String!
    var userId: Int!
    var subCategoryId: Int!
    var companyId: Int!
    var details: String!
    var detailedAddress: String!
    var viewCount: Int!
    var latitude: String!
    var longitude: String!
    var creationTime: String!
    var adImages : [AdImage]!
    var adType: AdType!
    var adTypeId: Int!
    var subCategory: Category!
    var user: User!
    var price: Int!
    var currency: Currency!
    var currencyId: Int!
    var placeArea: Int!
    var regionId: Int!
    var phoneNumber: String!
    var company: Company!
    var companyName: String!
    var isFavourite: Bool!
    var itemStateId: Int!
    var additionalFacilities: [AdditionalFacility]!
    
    
    /*
     public int Id;
     public String Title;
     public int Fk_User;
     public int Fk_SubCategory;
     public String About;
     public String Address;
     public String Longitude;
     public String Latitude;
     public int ViewCount;
     public String CreatedAt;
     public List<UserItemImageModel> UserItemImagesModel;
     public ItemTypeModel ItemTypeModel;
     public int Fk_ItemType;
     public SubCategoryModel SubCategoryModel;
     public UserModel UserModel;
     public int Fk_ItemState;
     public ItemStateModel ItemStateModel;
     
     
     public String UpdatedAt;
     public List<UserItemFavoriteModel> UserItemFavoritesModel;
     public List<UserItemMainModel> UserItemMainsModel;
     */
    
    //MARK: Decodable
    required public init?(json: JSON){
        id = "Id" <~~ json
        name = "Title" <~~ json
        userId = "Fk_User" <~~ json
        companyId = "Fk_Company" <~~ json
        subCategoryId = "Fk_SubCategory" <~~ json
        details = "About" <~~ json
        placeArea = "Space" <~~ json
        detailedAddress = "Address" <~~ json
        latitude = "Latitude" <~~ json
        longitude = "Longitude" <~~ json
        viewCount = "ViewCount" <~~ json
        creationTime = "CreatedAt" <~~ json
        adImages = "UserItemImagesModel" <~~ json
        adType = "ItemTypeModel" <~~ json
        adTypeId = "Fk_ItemType" <~~ json
        subCategory = "SubCategoryModel" <~~ json
        user = "UserModel" <~~ json
        itemStateId = "Fk_ItemState" <~~ json
        price = "Price" <~~ json
        currency = "CurrencyModel" <~~ json
        currencyId = "FK_Currency" <~~ json
        phoneNumber = "Phone" <~~ json
        regionId = "FK_Location" <~~ json
        isFavourite = "IsFavourite" <~~ json
        company = "CompanyModel" <~~ json
        companyName = company.name
        additionalFacilities = "UserItemFeaturesModel" <~~ json
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "id" ~~> id,
            "Title" ~~> name,
            "Fk_User" ~~> userId,
            "Fk_Company" ~~> companyId,
            "Fk_SubCategory" ~~> subCategoryId,
            "Price" ~~> price,
            "About" ~~> details,
            "Space" ~~> placeArea,
            "Address" ~~> detailedAddress,
            "ViewCount" ~~> viewCount,
            "Latitude" ~~> latitude,
            "Longitude" ~~> longitude,
            "creationTime" ~~> creationTime,
            "UserItemImagesModel" ~~> adImages,
            "ItemTypeModel" ~~> adType,
            "Fk_ItemType" ~~> adTypeId,
            "SubCategoryModel" ~~> subCategory,
            "UserModel" ~~> user,
//            "ItemStateModel" ~~> farshLevel,
            "Fk_ItemState" ~~> itemStateId,
            "CurrencyModel" ~~> currency,
            "FK_Currency" ~~> currencyId,
            "FK_Location" ~~> regionId,
            "Phone" ~~> phoneNumber,
            "IsFavourite" ~~> isFavourite,
            "CompanyModel" ~~> company,
            "UserItemFeaturesModel" ~~> additionalFacilities,
            ])
    }
    
    public init() {
        
    }
    
    public init(id: Int, name: String, imagesUrls: [String], price: String, currency: Currency, details: String, category: Category, adType: AdType, country: Country, region: Region, detailedAddress: String, latitude: Double, longitude: Double, farshLevel: FarshLevel, roomsNumber: Int, bathRoomsNumber: Int, additionalFacilities: [AdditionalFacility]) {
        self.id = id
        self.name = name
//        self.imagesUrls = imagesUrls
//        self.price = price
        self.currency = currency
        self.details = details
        self.subCategory = category
        self.adType = adType
//        self.country = country
//        self.region = region
        self.detailedAddress = detailedAddress
//        self.latitude = latitude
//        self.longitude = longitude
//        self.farshLevel = farshLevel
//        self.roomsNumber = roomsNumber
//        self.bathRoomsNumber = bathRoomsNumber
        self.additionalFacilities = additionalFacilities
    }
}
