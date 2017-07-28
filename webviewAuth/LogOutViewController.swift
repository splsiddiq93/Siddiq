//
//  LogOutViewController.swift
//  webviewAuth
//
//  Created by user on 7/21/17.
//  Copyright © 2017 full. All rights reserved.
//

import UIKit

class LogOutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logout(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let signinPage = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let accesstoken = UserDefaults.standard.string(forKey: "AccessToken")
        revoke(token: accesstoken!)
        if accesstoken != nil {
            self.navigationController?.pushViewController(signinPage, animated: true)
        }
        
    }
    
    func revoke(token: String) {
        print("called")
        let urlString = "https://accounts.google.com/o/oauth2/revoke?token="+token+""
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            UserDefaults.standard.removeObject(forKey: "AccessToken")
        }).resume()
    }
}
