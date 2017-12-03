//
//  LocationSearchTableViewController.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 12. 03..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import UIKit

class LocationSearchTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchResults = [SearchResult]()
    let googleApiKey = "AIzaSyD9xGRYapFoX0Q84tiunb2IpmgOVnB5mDs"
    var parentEditOfferVC: EditOfferTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSearchResultCell", for: indexPath)

        cell.textLabel?.text = searchResults[indexPath.row].description

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getLocationDetailsBy(searchResult: searchResults[indexPath.row])
    }

    // MARK: - Helpers
    
    func searchLocationAtGoogle(_ search: String) {
        searchResults = []
        
        if(search.count > 2) {
            let urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?language=en&types=address&input=\(search)&region=hu&sensor=true&key=\(googleApiKey)"
            
            let url: URL = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            let request = URLRequest(url: url)
            
            if(!urlString.isEmpty)
            {
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    if let error = error {
                        print("Error during comminication: \(error.localizedDescription).")
                        return
                    } else if let data = data {
                        if let string = String(data: data, encoding: .utf8) {
                            let jsonString = try? JSONSerialization.jsonObject(with: string.data(using: String.Encoding.utf8)!, options: []) as! [String: Any]
                            if let predictions = (jsonString!["predictions"] as? [[String: Any]]) {
                                for prediction in predictions {
                                    self.searchResults.append(SearchResult(placeId: prediction["place_id"]! as! String, description: prediction["description"]! as! String))
                                }
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                        } else {
                            print("not a valid UTF-8 sequence")
                        }
                    }
                }).resume()
            }
        }
    }
    
    func getLocationDetailsBy(searchResult: SearchResult) -> Void {
        let urlString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(searchResult.placeId)&key=\(googleApiKey)"
        
        let url: URL = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        let request = URLRequest(url: url)
        
        if(!urlString.isEmpty)
        {
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let error = error {
                    print("Error during comminication: \(error.localizedDescription).")
                    return
                } else if let data = data {
                    if let string = String(data: data, encoding: .utf8) {
                        let jsonString = try? JSONSerialization.jsonObject(with: string.data(using: String.Encoding.utf8)!, options: []) as! [String: Any]
                        if let result = (jsonString!["result"] as? [String: Any]), let geometry = (result["geometry"] as? [String: Any]), let location = (geometry["location"] as? [String: Any]) {
                            
                            self.parentEditOfferVC?.selectedLocation = SelectedLocation(placeId: searchResult.placeId, description: searchResult.description, latitude: location["lat"] as! Double, longitude: location["lng"] as! Double)

                            DispatchQueue.main.async {
                                _ = self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } else {
                        print("not a valid UTF-8 sequence")
                    }
                }
            }).resume()
        }
    }
    
}

extension LocationSearchTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchLocationAtGoogle(searchText)
    }
}


