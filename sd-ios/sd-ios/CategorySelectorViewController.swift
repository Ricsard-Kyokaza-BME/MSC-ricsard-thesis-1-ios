//
//  CategorySelectorViewController.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 12. 02..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import UIKit
import Feathers

class CategorySelectorViewController: UITableViewController {

    var parentOffersVC: OffersTableViewController?
    var parentEditOfferVC: EditOfferTableViewController?
    var categories = [Category]()
    var selectedCategories = [String: Bool]()
    var feathers: Feathers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        feathers = (UIApplication.shared.delegate as! AppDelegate).feathersRestApp
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        feathers = (UIApplication.shared.delegate as! AppDelegate).feathersRestApp
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Filter categories"
        
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
                        self.categories.append(decodedCategory)
                    } catch {
                        print(error)
                    }
                }
                
                self.tableView.reloadData()
            })
            .start()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategorySelectorCell", for: indexPath)
        
        if let parentOffersVC = parentOffersVC {
            cell.textLabel?.text = categories[indexPath.row].name
            cell.detailTextLabel?.text = parentOffersVC.selectedCategories[categories[indexPath.row]._id]! ? "✓" : ""
        }
        
        if let parentEditOfferVC = parentEditOfferVC {
            cell.textLabel?.text = categories[indexPath.row].name
            cell.detailTextLabel?.text = parentEditOfferVC.selectedCategories[categories[indexPath.row]._id]! ? "✓" : ""
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let parentOffersVC = parentOffersVC {
            parentOffersVC.selectedCategories[categories[indexPath.row]._id] = !parentOffersVC.selectedCategories[categories[indexPath.row]._id]!
            self.tableView.reloadData()
        }
        
        if let parentEditOfferVC = parentEditOfferVC {
            parentEditOfferVC.selectedCategories[categories[indexPath.row]._id] = !parentEditOfferVC.selectedCategories[categories[indexPath.row]._id]!
            self.tableView.reloadData()
        }
    }

}
