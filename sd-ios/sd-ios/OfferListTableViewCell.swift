//
//  OfferListTableViewCell.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 11. 19..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import UIKit

class OfferListTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
