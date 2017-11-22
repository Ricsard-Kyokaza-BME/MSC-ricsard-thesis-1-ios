//
//  ImageDownloader.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 11. 22..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import Foundation
import UIKit

public class ImageDownloader {
    static func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    public static func downloadImage(url: URL, imageView: UIImageView) {
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }
    }
}
