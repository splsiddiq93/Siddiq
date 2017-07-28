//
//  ViewController.swift
//  webviewAuth
//
//  Created by user on 7/18/17.
//  Copyright © 2017 full. All rights reserved.
//

import UIKit
import  SafariServices

class ViewController: UIViewController,SFSafariViewControllerDelegate {
    
    var safariVC: SFSafariViewController?
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        safariVC?.delegate = self
    }
    
    @IBAction func SignInWithGoogle(_ sender: Any) {
        safariVC = SFSafariViewController(url: NSURL(string: "https://accounts.google.com/o/oauth2/v2/auth?scope=email%20profile&response_type=code&state=security_token%3D138r5719ru3e1%26url%3D&redirect_uri=com.googleusercontent.apps.988336168745-kh45geolsueim5pp3r0n1hhn7hug8j3l:/oauth2redirect&client_id=988336168745-kh45geolsueim5pp3r0n1hhn7hug8j3l.apps.googleusercontent.com")! as URL)
        self.present(safariVC!, animated: true, completion: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(safariLogin(_:)), name: Notification.Name("CallbackNotification"), object: nil)
        
    }
    
    func reload(authcode:String){
        
        let url = URL(string: "https://www.googleapis.com/oauth2/v3/token/")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "POST"
        let bodyData = "code="+authcode+"&client_id=988336168745-kh45geolsueim5pp3r0n1hhn7hug8j3l.apps.googleusercontent.com&redirect_uri=com.googleusercontent.apps.988336168745-kh45geolsueim5pp3r0n1hhn7hug8j3l:/oauth2redirect&grant_type=authorization_code"
        request.httpBody = bodyData.data(using: String.Encoding.utf8);
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                //print("error=\(error)")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
            }
            
//            let responseString = String(data: data, encoding: .utf8)
//           print("responseString = \(responseString!)")
            let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            print(jsonDict!)
            for (key,value) in jsonDict!  {
                if key as!  String == "access_token" {
                    print(value)
                    self.userInfo(accesstoken: value as! String)
                    UserDefaults.standard.set(value, forKey: "AccessToken")
                }
            }

            
        }
        task.resume()
    }
    
    func safariLogin(_ notification : Notification) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("CallbackNotification"), object: nil)
        self.safariVC?.dismiss(animated: true, completion: nil)
        let detailsViewer = self.storyBoard.instantiateViewController(withIdentifier: "UserData") as! UITabBarController
        self.navigationController?.pushViewController(detailsViewer, animated: true)

    }
    
    
    func userInfo(accesstoken: String){
        
        let access = "https://www.googleapis.com/oauth2/v2/userinfo?access_token="+accesstoken+""
        let url = URL(string: access)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            do {
                let userData = try JSONSerialization.jsonObject(with: data!, options:[]) as? [String:AnyObject]
                let name = userData!["name"] as! String
                print(name)
                UserDefaults.standard.set(name, forKey: "userName")
                let email = userData!["email"] as! String
                print(email)
                UserDefaults.standard.set(email, forKey: "userEmail")
                let pic = userData!["picture"] as! String
                print(pic)
                UserDefaults.standard.set(pic, forKey: "imageURL")
                UserDefaults.standard.synchronize()

                } catch {
                print("Account Information could not be loaded")
            }

        }).resume()
    }
    
    
}




