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

class ViewController: UIViewController{

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var loginButton: MaterialButton!
    var firstName = ""
    var  profileImgUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        

        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
         //If user is already logged into Facebook, send them on to the app
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            
            print("already logged in")
            returnUserData()
            print("logged in results")
            
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
        
    }
   
    @IBAction func fbButtonPressed(sender: UIButton){
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email","public_profile"], fromViewController: nil, handler: {
            (facebookResult, facebookError) -> Void in
            
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
                //self.returnUserData()
            let userID = FBSDKAccessToken.currentAccessToken().userID
                let params = ["fields": "id,name,first_name"]
                let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
            
                graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                    
                    if ((error) != nil)
                    {
                        // Process error
                        print("User Data Error1: \(error)")
                    }
                    else
                    {
                        print("fetched user1: \(result)")
                        let first_Name: NSString = result.valueForKey("first_name") as! NSString
                        self.firstName = first_Name as String
                        print("First Name is1: \(first_Name)")
                        
                    }
                })

                
                var graphProfileURL = NSURL(string: "https://graph.facebook.com/?id=\(userID)&access_token=\(accessToken)")
                
                
                var request1: NSURLRequest = NSURLRequest(URL: graphProfileURL!)
                var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
                var error: NSErrorPointer = nil
                var dataVal: NSData
                do{
                    
                
                dataVal =  try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
                
                    let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    print("Synchronous\(jsonResult)")
                }catch {}
                var err: NSError
                print(response)
               

                
                //let firstName = "Geno"
                
                self.profileImgUrl = "http://graph.facebook.com/\(userID)/picture?type=large"
                //get fb profile picture
                FB_FIRST_NAME = self.firstName
                FB_PROFILE_URL = self.profileImgUrl

                
               DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        
                        if error != nil {
                            print("Login failed. \(error)")
                        } else {
                            print("Logged in! \(authData)")
                            let user = ["provider": authData.provider!, "profileImgUrl": self.profileImgUrl, "firstName": self.firstName]
                            DataService.ds.createFirebaseUser(authData.uid, user: user)
                            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                            NSUserDefaults.standardUserDefaults().setValue(FB_PROFILE_URL, forKey: self.profileImgUrl)
                            NSUserDefaults.standardUserDefaults().setValue(FB_FIRST_NAME, forKey: self.firstName)
                            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                        }
                })
            }
        })
        print("called after login check")
       // returnUserData()
    }

    @IBAction func attemptLogin(sender: UIButton!){
        if let email = emailField.text where email != "", let pwd = pwdField.text where pwd != "" {
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: {error, authData in
                if error != nil {
                    print(error.code)
                    if error.code == STATUS_ACCT_NONEXIST {
                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: {error, result in
                            if error != nil{
                                self.showErrorAlert("Could not create account" , msg: "Try something else")
                            }else{
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock:{error, authdata in
                                    let user = ["provider": authdata.provider!]
                                    DataService.ds.createFirebaseUser(authdata.uid, user: user)
                                
                                
                                })
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                                
                            }
                        })
                    }else{
                       self.showErrorAlert("Could not login.", msg: "Please check your username or password.")
                    }
                }else{
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
            })
            
            
        }else{
            print("You must enter an email address and password combination.")
        }
    }
    
    func showErrorAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func returnUserData()
    {
        
        /*FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
            initWithGraphPath:@"/me"
        parameters:@{ @"fields": @"id,name,picture",}
        HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        // Insert your code here
        }];*/
        
        let params = ["fields": "id,first_name"]
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
        
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("User Data Error2: \(error)")
            }
            else
            {
                print("fetched user2: \(result)")
                let userName : NSString = result.valueForKey("first_name") as! NSString
                print("User Name is2: \(userName)")
                let userID = FBSDKAccessToken.currentAccessToken().userID
                FB_PROFILE_URL = "http://graph.facebook.com/\(userID)/picture?type=large"
                FB_FIRST_NAME = userName as String
            }
        })
       

    }
}

