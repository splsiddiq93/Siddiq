//
//  DetailsViewController.swift
//  webviewAuth
//
//  Created by user on 7/19/17.
//  Copyright © 2017 full. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    
    var fullName : String?
    var email_id : String?
    var photoURL = UserDefaults.standard.string(forKey: "imageURL")
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullName = UserDefaults.standard.string(forKey: "userName") ?? "No name"
        email_id = UserDefaults.standard.string(forKey: "userEmail") ?? "No mail"
        name.text = fullName
        email.text = email_id
        let urlimage = URL(string: photoURL ?? "no image")
        downloadImage(url: urlimage!)
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
}
