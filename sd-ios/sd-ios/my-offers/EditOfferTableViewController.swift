//
//  EditOfferTableViewController.swift
//  sd-ios
//
//  Created by Richárd Balog on 2017. 12. 02..
//  Copyright © 2017. Richárd Balog. All rights reserved.
//

import UIKit
import Feathers

class EditOfferTableViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    
    var selectedCategories = [String: Bool]()
    var offer: Offer?
    var isOfferEditing = false
    var feathers: Feathers
    var selectedLocation: SelectedLocation?
    
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
        
        feathers = (UIApplication.shared.delegate as! AppDelegate).feathersRestApp
        getCategories()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                                 style: UIBarButtonItemStyle.plain,
                                                                 target: self, action: #selector(saveClick))
        
        if let offer = offer {
            isOfferEditing = true
            
            if let images = offer.images, images.count > 0, let url = URL(string: Constants.fileServer + images[0]) {
                imageView.contentMode = .scaleAspectFit
                ImageDownloader.downloadImage(url: url, imageView: imageView)
            } else {
                imageView.image = UIImage(named: "no_image")
            }
            
            navigationItem.title = offer.title
            titleTextField.text = offer.title
            descriptionTextView.text = offer.description
            priceTextField.text = offer.price
            
        } else {
            isOfferEditing = false
            
            navigationItem.title = "New offer"
            imageView.image = UIImage(named: "no_image")
        }
    }
    
    @IBAction func showCategoriesClick(_ sender: Any) {
    }
    
    @IBAction func saveClick(_ sender: Any) {
        var url: URL?
        var request: URLRequest?
        
        if isOfferEditing, let offer = offer {
            offer.title = titleTextField.text!
            offer.description = descriptionTextView.text!
            offer.price = priceTextField.text!
            offer.categories = getSelectedCategoriesList()
            
            if let location = selectedLocation, let lat = selectedLocation?.latitude, let lng = selectedLocation?.longitude {
                offer.address = location.description
                offer.coordinates = [lat, lng]
            }
            
            url = URL(string: Constants.api + "/\(Constants.offerService)/" + offer._id!)
            request = URLRequest(url: url!)
            request?.httpMethod = "PATCH"
        } else {
            offer = Offer(nil, title: titleTextField.text!, description: descriptionTextView.text!, price: priceTextField.text!, categories: getSelectedCategoriesList(), owner: (AuthManager.manager.getSignedInUser()?._id)!, images: [], address: selectedLocation?.description, coordinates: nil, createdAt: Date(), updatedAt: Date())
            
            if let lat = selectedLocation?.latitude, let lng = selectedLocation?.longitude {
                offer?.coordinates = [lat, lng]
            }
            
            url = URL(string: Constants.api + "/\(Constants.offerService)")
            request = URLRequest(url: url!)
            request?.httpMethod = "POST"
        }

        saveImage { imageId in
            do {
                if (self.offer?.images) != nil {
                    self.offer?.images = []
                    self.offer?.images?.append(imageId)
                } else {
                    self.offer?.images = [imageId]
                }
                
                let encoder = JSONEncoder()
                let encodedUser = try encoder.encode(self.offer)
                
                request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request?.setValue(AuthManager.manager.getAccessToken()!, forHTTPHeaderField: "authorization")
                request?.httpBody = encodedUser
                
                URLSession.shared.dataTask(with: request!, completionHandler: { (data, response, error) in
                    if let error = error {
                        print("Error during comminication: \(error.localizedDescription).")
                        return
                    } else if data != nil {
                        DispatchQueue.main.async {
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
                }).resume()
            } catch {
                print(error)
            }
        }
    }
    
    func saveImage(completeHandler: @escaping (_ imageId: String) -> Void) {
        if let image = imageView.image, let jpegImageData = UIImageJPEGRepresentation(image, 0.8) {
            let url = URL(string: Constants.fileServer)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = createBody(parameters: [:],
                                          boundary: boundary,
                                          data: jpegImageData,
                                          mimeType: "image/jpg",
                                          filename: "ios_upload.jpg")
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let error = error {
                    print("Error during comminication: \(error.localizedDescription).")
                    return
                } else if let data = data {
                    if let string = String(data: data, encoding: .utf8) {
                        let jsonString = try? JSONSerialization.jsonObject(with: string.data(using: String.Encoding.utf8)!, options: []) as! [String]
                        completeHandler(jsonString![0])
                    } else {
                        print("not a valid UTF-8 sequence")
                    }
                }
            }).resume()
        }
    }
    
    @IBAction func deleteClick(_ sender: Any) {
        if let offer = offer {
            let url = URL(string: Constants.api + "/\(Constants.offerService)/" + offer._id!)
            var request = URLRequest(url: url!)
            request.httpMethod = "DELETE"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(AuthManager.manager.getAccessToken()!, forHTTPHeaderField: "authorization")
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let error = error {
                    print("Error during comminication: \(error.localizedDescription).")
                    return
                } else if data != nil {
                    DispatchQueue.main.async {
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                }
            }).resume()
        }
    }
    
    @IBAction func imageViewTap(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }

    func createBody(parameters: [String: String],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        let body = NSMutableData()
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"files\"; filename=\"img.jpg\"\r\n")
        body.appendString("Content-Type: image/jpeg\r\n")
        body.appendString("Content-Transfer-Encoding: binary\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        
        return body as Data
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
                        
                        self.selectedCategories[decodedCategory._id] = false
                    } catch {
                        print(error)
                    }
                }
                
                if let offer = self.offer, let categories = offer.categories, categories.count > 0 {
                    for categoryId in categories {
                        self.selectedCategories[categoryId] = true
                    }
                }
            })
            .start()
    }
    
    func getSelectedCategoriesList() -> [String] {
        return selectedCategories.filter({ (key: String, value: Bool) -> Bool in
            return value
        }).map({ (key: String, value: Bool) -> String in
            return key
        })
    }
    
    //   MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewOfferCategorySelectorSegue" {
            let vc = segue.destination as? CategorySelectorViewController
            vc?.selectedCategories = self.selectedCategories
            vc?.parentEditOfferVC = self
        } else if segue.identifier == "EditOfferSearchLocationSegue" {
            let vc = segue.destination as? LocationSearchTableViewController
            vc?.parentEditOfferVC = self
        }
    }
}

extension EditOfferTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
