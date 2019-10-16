//
//  ViewController.swift
//  FirebaseAuth
//
//  Created by Ye Ko Ko Htet on 15/10/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseUI

struct FacebookPermission
{
    static let NAME: String = "name"
    static let PROFILE_PIC: String = "picture"
}

class ViewController: UIViewController {
    
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnFBLogin: FBLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let loginButton: FBLoginButton! = FBLoginButton()
////        // Optional: Place the button in the center of your view.
//        loginButton.center = self.view.center
//        self.view.addSubview(loginButton)
//
//        loginButton.delegate = self
        
        btnFBLogin.delegate = self
    }
    
    func getFacebookData()
    {
        let graphRequest: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields" : "\(FacebookPermission.NAME), \(FacebookPermission.PROFILE_PIC).type(large)"])

        graphRequest.start { (connection: GraphRequestConnection?, result: Any?, error: Error?) in

            if error == nil
            {
                if let facebookData = result as? NSDictionary
                {
                    if let userName = facebookData.value(forKey: FacebookPermission.NAME) as? String
                    {
                        print("Username: \(userName)")
                        self.lblUserName.text = userName
                    }

                    if let profilePic = facebookData.value(forKey: FacebookPermission.PROFILE_PIC)
                    {
                        let facebookImageURL = ((profilePic as AnyObject).value(forKey: "data") as AnyObject).value(forKey: "url") as? String

                        if let unwrappedURL = facebookImageURL
                        {
                            let imageData: Data = try! Data(contentsOf: URL(string: unwrappedURL)!)
                            self.ivProfile.image = UIImage(data: imageData)!
                        }
                    }
                }
            }
            else
            {
                print("Facebook Graph Request Error")
            }
        }
    }

}

extension ViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if AccessToken.isCurrentAccessTokenActive {
            getFacebookData()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        ivProfile.image = UIImage(named: "")
        lblUserName.text = ""
    }
}


