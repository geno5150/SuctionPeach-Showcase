//
//  DataService.swift
//  SuctionPeach-Showcase
//
//  Created by Geno Erickson on 12/21/15.
//  Copyright © 2015 SuctionPeach. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://resplendent-fire-7815.firebaseio.com"

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_POSTS = Firebase(url:"\(URL_BASE)/posts")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    
    

    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_USERS: Firebase {
        return _REF_USERS
    }
    
    var REF_POSTS: Firebase {
        return _REF_POSTS
    }
    
    var REF_CURRENT_USER: Firebase {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = Firebase(url: "\(URL_BASE)").childByAppendingPath("users").childByAppendingPath(uid)
        return user!
        
    }
    
    var REF_CURRENT_PROFILE_IMG: Firebase {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let profileImgUrl = Firebase(url: "\(URL_BASE)").childByAppendingPath("users").childByAppendingPath(uid).childByAppendingPath("profileImgUrl")
        return profileImgUrl!
        
    }
    
    var REF_FIRST_NAME: Firebase {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let firstName = Firebase(url: "\(URL_BASE)").childByAppendingPath("users").childByAppendingPath(uid).childByAppendingPath("firstName")
        return firstName!
        
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        REF_USERS.childByAppendingPath(uid).setValue(user)
        
        
    }
}