//
//  CountriesListVC.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 9/5/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import UIKit

public protocol CountriesListDelegate: class {
    func countrySelected(country: Country?)
}

class CountriesListVC: BaseVC {

    public class func buildVC(countries: [Country]) -> CountriesListVC {
        let storyboard = UIStoryboard(name: "CountriesListStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CountriesListVC") as! CountriesListVC
        vc.countries = countries
        return vc
    }

    var countries = [Country]()
    var filteredCountries = [Country]()
    
    var delegate: CountriesListDelegate?
    var searchActive : Bool = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var countriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        countriesTableView.dataSource = self
        countriesTableView.delegate = self
        countriesTableView.reloadData()
    }
    
}

extension CountriesListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredCountries.count > 0 {
            return filteredCountries.count
        }
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountriesListCell.identifier, for: indexPath) as! CountriesListCell
        
        cell.selectionStyle = .none
        if filteredCountries.count > 0 {
            cell.country = filteredCountries.get(indexPath.row)
        } else {
            cell.country = countries.get(indexPath.row)
        }
        cell.populateData()
        cell.contentView.addTapGesture { [weak self] (_) in
            self?.delegate?.countrySelected(country: self?.countries.get(indexPath.row))
            self?.navigationController?.popViewController(animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UiHelpers.getLengthAccordingTo(relation: .SCREEN_HEIGHT, relativeView: nil, percentage: 5)
    }
}

extension CountriesListVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCountries = countries.filter({ (country) -> Bool in
            let tmp: Country = country
            return tmp.name.contains(searchText, compareOption: .caseInsensitive)
        })
        
        if(filteredCountries.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.countriesTableView.reloadData()
    }
}
