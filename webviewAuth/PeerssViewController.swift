//
//  PeerssViewController.swift
//  webviewAuth
//
//  Created by user on 7/25/17.
//  Copyright © 2017 full. All rights reserved.
//

import UIKit

class PeerssViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableview: UITableView!
    
    var dataArray : [Any] = []
    var emailArray : [Any] = []
    var imageArray : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuse", for: indexPath) as! TableViewCell
        cell.one.text = dataArray[indexPath.row] as? String
        cell.two.text = emailArray[indexPath.row] as? String
        let urlstring = imageArray[indexPath.row]
        let url = URL(string: urlstring as! String)
        cell.imageview.image =  self.downloadImage(url: url!) as? UIImage
        
        return cell
    }
    
    @IBAction func randomuser(_ sender: Any) {
        let urlString = "https://randomuser.me/api/?format=json&inc=name,email,picture"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            let jsonDict = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
            print(jsonDict!)
            for (key,valu) in jsonDict! {
                if key == "results"{
                    let data = valu as! [[String:Any]]
                    
                    for details in data{
                        for (key,value) in details{
                            if key == "name" {
                                let some = value as! [String:Any]
                                for (ke, val) in some{
                                    if ke == "last"{
                                        self.dataArray.append(val)
                                        DispatchQueue.main.async(execute: {
                                            self.tableview.reloadData()
                                        })
                                    }
                                }
                            } else if key == "email" {
                                self.emailArray.append(value)
                                DispatchQueue.main.async(execute: {
                                    self.tableview.reloadData()
                                })
                            } else if key == "picture" {
                                let images = value as! [String: Any]
                                print(images)
                                for (typeofImage, imageUrl) in images{
                                    if typeofImage == "thumbnail" {
                                        self.imageArray.append(imageUrl)
                                        DispatchQueue.main.async(execute: {
                                            self.tableview.reloadData()
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }).resume()
        
    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) ->Any {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                //self.imageview.image = UIImage(data: data)
                return data
            }
        }
        return (Any).self
    }
    
    
}
