//
//  HomeTabBarController.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 11. 16..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import UIKit
import Feathers
import FeathersSwiftRest

class HomeTabBarController: UITabBarController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var feathers: Feathers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        feathers = appDelegate.feathersRestApp
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        feathers = appDelegate.feathersRestApp
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feathers = appDelegate.feathersRestApp
        
        let offerService = feathers.service(path: "offers")
        
        let query = Query().limit(100)
        
        offerService.request(.find(query: query))
            .on(value: { response in
                print(response)
            })
            .start()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

