//
//  OfferDetailViewController.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 11. 19..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import UIKit
import MapKit

class OfferDetailViewController: UITableViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    var offer: Offer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let offer = offer {
            if let images = offer.images, images.count > 0, let url = URL(string: Constants.fileServer + images[0]) {
                imageView.contentMode = .scaleAspectFit
                ImageDownloader.downloadImage(url: url, imageView: imageView)
            } else {
                imageView.image = UIImage(named: "no_image")
            }
            
            navigationItem.title = offer.title
            textView.text = offer.description
            if let coordinates = offer.coordinates {
                let location = CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1])
                mapView.setCenter(location, animated: true)
                
                let viewRegion = MKCoordinateRegionMakeWithDistance(location, 300, 300)
                mapView.setRegion(viewRegion, animated: false)
                
                let locationAnnotation = MKPointAnnotation()
                locationAnnotation.coordinate = location
                locationAnnotation.title = offer.address
                
                mapView.addAnnotation(locationAnnotation)
            }
            
        }
    }

}
