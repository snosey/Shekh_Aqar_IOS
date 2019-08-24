//
//  HomeVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/18/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit
import Localize_Swift
import MapKit

class HomeVC: BaseVC {

    public class func buildVC() -> HomeVC {
        let storyboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
    }
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var sideMenuIcon: UIImageView!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var showMapButton: LocalizedButton!
    @IBOutlet weak var showImagesButton: LocalizedButton!
    @IBOutlet weak var left1ImageView: UIImageView!
    @IBOutlet weak var left2ImageView: UIImageView!
    @IBOutlet weak var left3ImageView: UIImageView!
    @IBOutlet weak var right1ImageView: UIImageView!
    @IBOutlet weak var right2ImageView: UIImageView!
    @IBOutlet weak var right3ImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var collectionView3: UICollectionView!
    
    var categories1 = [Category]()
    var categories2 = [Category]()
    var categories3 = [Category]()
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GradientBG.createGradientLayer(view: topView, cornerRaduis: 0, maskToBounds: false)
        
        GradientBG.createGradientLayer(view: showMapButton, cornerRaduis: 8, maskToBounds: true)
        
        showImagesButton.layer.borderColor = UIColor.AppColors.textColor.cgColor
        showImagesButton.layer.borderWidth = 1
        showImagesButton.setTitleColor(UIColor.AppColors.textColor, for: .normal)
        
        showMapButton.addTapGesture { [weak self] (_) in
            GradientBG.createGradientLayer(view: self?.showMapButton ?? UIView(), cornerRaduis: 8, maskToBounds: true)
            self?.showMapButton.setTitleColor(UIColor.black, for: .normal)
            
            self?.showImagesButton.layer.sublayers?.remove(at: 0)
            self?.showImagesButton.layer.borderColor = UIColor.AppColors.textColor.cgColor
            self?.showImagesButton.layer.borderWidth = 1
            self?.showImagesButton.setTitleColor(UIColor.AppColors.textColor, for: .normal)
            
            self?.tableView.isHidden = true
            self?.mapView.isHidden = false
        }
        
        showImagesButton.addTapGesture { [weak self] (_) in
            GradientBG.createGradientLayer(view: self?.showImagesButton ?? UIView(), cornerRaduis: 8, maskToBounds: true)
            self?.showImagesButton.setTitleColor(UIColor.black, for: .normal)
            
            self?.showMapButton.layer.sublayers?.remove(at: 0)
            self?.showMapButton.layer.borderColor = UIColor.AppColors.textColor.cgColor
            self?.showMapButton.layer.borderWidth = 1
            self?.showMapButton.setTitleColor(UIColor.AppColors.textColor, for: .normal)
            
            self?.tableView.isHidden = false
            self?.mapView.isHidden = true
        }
        
        changeArrows()
        
        setupScrollableViews()
        
        createFakeCategories()
        
        collectionView1.reloadData()
        collectionView2.reloadData()
        collectionView3.reloadData()
    }
    
    private func createFakeCategories() {
        let category1 = Category(id: 1, nameEn: "Category 1", nameAr: "مثمن عقاري", key: "cat1")
        let category2 = Category(id: 2, nameEn: "Category 2", nameAr: "طلبات العقارات", key: "cat1")
        let category3 = Category(id: 3, nameEn: "Category 3", nameAr: "شقق للايجار", key: "cat1")
        let category4 = Category(id: 4, nameEn: "Category 4", nameAr: "فلل للايجار", key: "cat1")
        let category5 = Category(id: 5, nameEn: "Category 5", nameAr: "شقق للبيع", key: "cat1")
        
        categories1.append(category1)
        categories1.append(category2)
        categories1.append(category3)
//        categories1.append(category4)
//        categories1.append(category5)
        
        categories2.append(category1)
        categories2.append(category2)
        categories2.append(category3)
        categories2.append(category4)
        categories2.append(category5)
        
        categories3.append(category1)
        categories3.append(category2)
        categories3.append(category3)
        categories3.append(category4)
        categories3.append(category5)
    }
    
    private func changeArrows() {
        if Localize.currentLanguage() == "ar" {
            left1ImageView.image = UIImage(named: "right_arrow")
            left2ImageView.image = UIImage(named: "right_arrow")
            left3ImageView.image = UIImage(named: "right_arrow")
            right1ImageView.image = UIImage(named: "left_arrow")
            right2ImageView.image = UIImage(named: "left_arrow")
            right3ImageView.image = UIImage(named: "left_arrow")
            
        }
    }
    
    private func setupScrollableViews() {
        collectionView1.dataSource = self
        collectionView1.delegate = self
        if let layout = collectionView1.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: UiHelpers.getLengthAccordingTo(relation: .SCREEN_WIDTH
                , relativeView: nil, percentage: 100), height: UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 10))
        }
        
        collectionView2.dataSource = self
        collectionView2.delegate = self
        if let layout = collectionView2.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: UiHelpers.getLengthAccordingTo(relation: .SCREEN_WIDTH
                , relativeView: nil, percentage: 100), height: UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 10))
        }
        
        collectionView3.dataSource = self
        collectionView3.delegate = self
        if let layout = collectionView3.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: UiHelpers.getLengthAccordingTo(relation: .SCREEN_WIDTH
                , relativeView: nil, percentage: 25), height: UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 10))
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            return categories1.count
        } else if collectionView == collectionView2 {
            return categories2.count
        } else if collectionView == collectionView3 {
            return categories3.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        if collectionView == collectionView1 {
             cell.category = self.categories1.get(indexPath.row)!
        } else if collectionView == collectionView2 {
            cell.category = self.categories2.get(indexPath.row)!
        } else if collectionView == collectionView3 {
            cell.category = self.categories3.get(indexPath.row)!
        }
        
        cell.populateData()
        cell.changeLabelToBeUnclicked()
        
        if cell.category.isClicked {
            cell.changeLabelToBeClicked()
        }
        
        cell.categoryNameButton.addTapGesture { [weak self](_) in
            if collectionView == self?.collectionView1 {
                var indexPathes1 = [IndexPath]()
                var count1 = 0
                for category in self?.categories1 ?? [] {
                    category.isClicked = false
                    indexPathes1.append(IndexPath(item: count1, section: 0))
                    count1 = count1 + 1
                }
                self?.categories1[indexPath.row].isClicked = true
                self?.collectionView1.reloadItems(at: indexPathes1)
                
                var indexPathes2 = [IndexPath]()
                var count2 = 0
                for category in self?.categories2 ?? [] {
                    category.isClicked = false
                    indexPathes2.append(IndexPath(item: count2, section: 0))
                    count2 = count2 + 1
                }
                self?.collectionView2.reloadItems(at: indexPathes2)
                
                var indexPathes3 = [IndexPath]()
                var count3 = 0
                for category in self?.categories3 ?? [] {
                    category.isClicked = false
                    indexPathes3.append(IndexPath(item: count3, section: 0))
                    count3 = count3 + 1
                }
                self?.collectionView3.reloadItems(at: indexPathes3)
                
            } else if collectionView == self?.collectionView2 {
                var indexPathes1 = [IndexPath]()
                var count1 = 0
                for category in self?.categories2 ?? [] {
                    category.isClicked = false
                    indexPathes1.append(IndexPath(item: count1, section: 0))
                    count1 = count1 + 1
                }
                self?.categories2[indexPath.row].isClicked = true
                self?.collectionView2.reloadItems(at: indexPathes1)
                
                var indexPathes2 = [IndexPath]()
                var count2 = 0
                for category in self?.categories1 ?? [] {
                    category.isClicked = false
                    indexPathes2.append(IndexPath(item: count2, section: 0))
                    count2 = count2 + 1
                }
                self?.collectionView1.reloadItems(at: indexPathes2)

                var indexPathes3 = [IndexPath]()
                var count3 = 0
                for category in self?.categories3 ?? [] {
                    category.isClicked = false
                    indexPathes3.append(IndexPath(item: count3, section: 0))
                    count3 = count3 + 1
                }
                self?.collectionView3.reloadItems(at: indexPathes3)
                
            } else if collectionView == self?.collectionView3 {
                var indexPathes1 = [IndexPath]()
                var count1 = 0
                for category in self?.categories3 ?? [] {
                    category.isClicked = false
                    indexPathes1.append(IndexPath(item: count1, section: 0))
                    count1 = count1 + 1
                }
                self?.categories3[indexPath.row].isClicked = true
                self?.collectionView3.reloadItems(at: indexPathes1)
                
                var indexPathes2 = [IndexPath]()
                var count2 = 0
                for category in self?.categories1 ?? [] {
                    category.isClicked = false
                    indexPathes2.append(IndexPath(item: count2, section: 0))
                    count2 = count2 + 1
                }
                self?.collectionView1.reloadItems(at: indexPathes2)
                
                var indexPathes3 = [IndexPath]()
                var count3 = 0
                for category in self?.categories2 ?? [] {
                    category.isClicked = false
                    indexPathes3.append(IndexPath(item: count3, section: 0))
                    count3 = count3 + 1
                }
                self?.collectionView2.reloadItems(at: indexPathes3)
            }
        }
        
        return cell
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CompanyCell.identifier, for: indexPath) as! CompanyCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 20)
    }
}
