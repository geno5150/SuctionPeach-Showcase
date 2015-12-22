//
//  ViewController.swift
//  SuctionPeach-Showcase
//
//  Created by Geno Erickson on 12/21/15.
//  Copyright © 2015 SuctionPeach. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
         //If user is already logged into Facebook, send them on to the app
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
        
    }
   
    @IBAction func fbButtonPressed(sender: UIButton){
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: nil, handler: {
            (facebookResult, facebookError) -> Void in
            
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
               DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        
                        if error != nil {
                            print("Login failed. \(error)")
                        } else {
                            print("Logged in! \(authData)")
                            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                        }
                })
            }
        })
    }

    @IBAction func attemptLogin(sender: UIButton!){
        if let email = emailField.text where email != "", let pwd = pwdField.text where pwd != "" {
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: {error, authData in
                if error != nil {
                    print(error.code)
                }
            })
            
        }else{
            print("You must enter an email address and password combination.")
        }
    }
    
    func showErrorAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let  action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}

