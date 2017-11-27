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
    var offers: [Offer]
  
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
//        self.tableView.backgroundColor = Constants.primaryColor
      
        feathers = appDelegate.feathersRestApp
        let offerService = feathers.service(path: "offers")
        let query = Query().limit(100)
        
        offerService.request(.find(query: query))
            .on(value: { response in
                let jsonDecoder = JSONDecoder()
                
                for offer in response.data.value as! Array<[String: Any]> {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: offer, options:  JSONSerialization.WritingOptions(rawValue: 0))
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
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return offers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        
        cell.backgroundColor = UIColor.white
        cell.tintColor = Constants.primaryColor
        cell.layer.borderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.15).cgColor
        cell.layer.borderWidth = 2

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    //   MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OfferDetailSegue" {
            let vc = segue.destination as? OfferDetailViewController
            let section = tableView.indexPathForSelectedRow?.section
            vc?.offer = offers[section!]
        }
    }

}
