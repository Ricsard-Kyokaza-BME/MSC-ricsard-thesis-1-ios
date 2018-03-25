//
//  OffersTableViewController.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 11. 16..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import UIKit
import Feathers
import FeathersSwiftRest

class OffersTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var feathers: Feathers
    var allOffers = [Offer]()
    var offers: [Offer]
    var selectedCategories = [String: Bool]()
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        feathers = appDelegate.feathersRestApp
        offers = []
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        feathers = appDelegate.feathersRestApp
        offers = []
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tempImageView = UIImageView(image: UIImage(named: "bg"))
        tempImageView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImageView;
        
        feathers = appDelegate.feathersRestApp
        let offerService = feathers.service(path: Constants.offerService)
        let query = Query().limit(100)
        
        offerService.request(.find(query: query))
            .on(value: { response in
                self.offers = []
                let jsonDecoder = JSONDecoder()
                
                for offer in response.data.value as! Array<[String: Any]> {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: offer, options: JSONSerialization.WritingOptions(rawValue: 0))
                        jsonDecoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
                        
                        let newOffer = try jsonDecoder.decode(Offer.self, from: jsonData)
                        self.offers.append(newOffer)
                        self.allOffers.append(newOffer)
                    } catch {
                        print(error)
                    }
                }
                
                if(self.selectedCategories.count > 0) {
                    self.filterOffers()
                }
                
                self.tableView.reloadData()
            })
            .start()
    }
    
    func filterOffers() -> Void {
        let selectedCategoriesList = self.getSelectedCategoriesList()
        self.offers = self.offers.filter({ (offer) -> Bool in
            for category in selectedCategoriesList {
                if(offer.categories?.contains(category))! {
                    return true
                }
            }
            return false
        })
    }
    
    func getSelectedCategoriesList() -> [String] {
        return selectedCategories.filter({ (key: String, value: Bool) -> Bool in
            return value
        }).map({ (key: String, value: Bool) -> String in
            return key
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return offers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfferTableViewCell", for: indexPath) as! OfferListTableViewCell
        
        cell.title?.text = offers[indexPath.section].title
        
        if let images = offers[indexPath.section].images, images.count > 0, let url = URL(string: Constants.fileServer + images[0]) {
            ImageDownloader.downloadImage(url: url, imageView: cell.offerImage)
        } else {
            cell.offerImage.image = UIImage(named: "no_image")
        }
        
        cell.descriptionTextView?.text = offers[indexPath.section].description
        cell.descriptionTextView?.sizeToFit()
        
        if let price = offers[indexPath.section].price {
            cell.price?.text = price + " Ft"
        }
        
        cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7)
        cell.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1).cgColor
        cell.layer.borderWidth = 1

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 326
    }
    
    func getCategories() {
        let categoryService = feathers.service(path: Constants.categoryService)
        let query = Query().limit(100)
        
        categoryService.request(.find(query: query))
            .on(value: { response in
                let jsonDecoder = JSONDecoder()
                
                for category in response.data.value as! Array<[String: Any]> {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: category, options:  JSONSerialization.WritingOptions(rawValue: 0))
                        jsonDecoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
                        
                        let decodedCategory = try jsonDecoder.decode(Category.self, from: jsonData)
                        
                        self.selectedCategories[decodedCategory._id] = true
                    } catch {
                        print(error)
                    }
                }
            })
            .start()
    }

    //   MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OfferDetailSegue" {
            let vc = segue.destination as? OfferDetailViewController
            let section = tableView.indexPathForSelectedRow?.section
            vc?.offer = offers[section!]
        } else if segue.identifier == "OffersCategorySelectorSegue" {
            let vc = segue.destination as? CategorySelectorViewController
            vc?.selectedCategories = self.selectedCategories
            vc?.parentOffersVC = self
        }
    }
}
