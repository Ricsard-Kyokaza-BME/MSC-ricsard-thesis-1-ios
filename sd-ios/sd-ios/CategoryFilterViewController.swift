//
//  CategoryFilterViewController.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 11. 26..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import UIKit

class CategoryFilterViewController: UIViewController {

  @IBOutlet var uiview: UIView!
  @IBOutlet weak var pickerView: UIPickerView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      uiview.isHidden = true
      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
