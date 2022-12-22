//
//  ViewController.swift
//  WalmartCodingTest
//
//  Created by Sai Suman Pothedar on 11/9/22.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var resultSearchController = UISearchController()
    @IBOutlet weak var countryTableView: UITableView!
    var filteredTableData = [Countries]()
    var fetchedCountriesList = [Countries]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseData()
        countryTableView.delegate = self
        countryTableView.dataSource = self
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            self.countryTableView.tableHeaderView = controller.searchBar
            return controller
        })()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        countryTableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.isActive {
            return self.filteredTableData.count
        }else{
            return self.fetchedCountriesList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        //        cell.name?.text = fetchedCountriesList[indexPath.row].name
        //        cell.region?.text = fetchedCountriesList[indexPath.row].region
        //        cell.code?.text = fetchedCountriesList[indexPath.row].code
        //        cell.capital?.text = fetchedCountriesList[indexPath.row].capital
        
        if self.resultSearchController.isActive {
            cell.name?.text = filteredTableData[indexPath.row].name
            cell.region?.text = filteredTableData[indexPath.row].region
            cell.code?.text = filteredTableData[indexPath.row].code
            cell.capital?.text = filteredTableData[indexPath.row].capital
            
        } else {
            cell.name?.text = fetchedCountriesList[indexPath.row].name
            cell.region?.text = fetchedCountriesList[indexPath.row].region
            cell.code?.text = fetchedCountriesList[indexPath.row].code
            cell.capital?.text = fetchedCountriesList[indexPath.row].capital
        }
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredTableData.removeAll()
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (fetchedCountriesList as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [Countries]
        self.countryTableView.reloadData()
    }
    
    
    private func parseData() {
        fetchedCountriesList = []
        
        let url = "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            if error != nil {
                print("error")
            }else{
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSArray
                    
                    for eachCountryList in json {
                        let eachCountry = eachCountryList as!  [String: Any]
                        let name = eachCountry["name"] as! String
                        let capital = eachCountry["capital"] as! String
                        let region = eachCountry["region"] as! String
                        let code = eachCountry["code"] as! String
                        
                        self.fetchedCountriesList.append(Countries(name: name, region: region, code: code, capital: capital))
                        
                        DispatchQueue.main.async {
                            self.countryTableView.reloadData()
                        }
                    }
                    
                } catch {
                    print("error2")
                }
            }
        })
        task.resume()
        
    }
    
}

