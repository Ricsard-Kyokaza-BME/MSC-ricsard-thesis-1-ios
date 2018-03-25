//
//  MyOffersTableViewController.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 12. 02..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import UIKit
import Feathers

class MyOffersTableViewController: UITableViewController {

    var feathers: Feathers?
    var offers = [Offer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tempImageView = UIImageView(image: UIImage(named: "bg"))
        tempImageView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImageView;
        
        if(!AuthManager.manager.isSignedIn) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            present(vc, animated: false, completion: nil)
        } else {
            feathers = (UIApplication.shared.delegate as! AppDelegate).feathersRestApp
            let offerService = feathers!.service(path: Constants.offerService)
            print(AuthManager.manager.getSignedInUser()!._id)
            let query = Query().eq(property: "owner", value: AuthManager.manager.getSignedInUser()!._id).limit(100)
            
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
                        } catch {
                            print(error)
                        }
                    }
                    
                    self.tableView.reloadData()
                })
                .start()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return offers.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOffersTableViewCell", for: indexPath) as! MyOffersTableViewCell
        
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
    
    //   MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyOfferDetailSegue" {
            let vc = segue.destination as? EditOfferTableViewController
            let section = tableView.indexPathForSelectedRow?.section
            vc?.offer = offers[section!]
        }
    }

}
