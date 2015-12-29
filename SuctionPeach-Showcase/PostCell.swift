//
//  PostCell.swift
//  SuctionPeach-Showcase
//
//  Created by Geno Erickson on 12/23/15.
//  Copyright © 2015 SuctionPeach. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import Social
import FBSDKShareKit

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet   weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionText : UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var postName: UILabel!
    @IBOutlet weak var fbShareButton: UIButton!
    var parentVC: FeedVC!
    let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
    
    
    //content.contentURL = NSURL(string: "<INSERT STRING HERE>")
    
    
   /* content.contentTitle = "Posting Method #2"
    content.contentDescription = "Description of the Content"
    content.imageURL = NSURL(string: "<INSERT STRING HERE>")
    */
    
    var post: Post!
    var request: Request?
    var request2: Request?
    var likeRef: Firebase!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.userInteractionEnabled = true
        
    }

    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        
        showcaseImg.clipsToBounds = true

    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(post: Post, img: UIImage?, upperVC: FeedVC){
        self.parentVC = upperVC
       self.post = post
        likeRef = DataService.ds.REF_CURRENT_USER.childByAppendingPath("likes").childByAppendingPath(post.postKey)
       
            self.descriptionText.text = post.postDescription
            self.likesLbl.text = "\(post.likes)"
        self.postName.text = post.firstName
        
        if post.imageURL != nil {
            if img != nil{
                self.showcaseImg.image = img
            
            }else{
                request = Alamofire.request(.GET, post.imageURL!).validate(contentType: ["image/*"]).response(completionHandler: {request, response, data, err in
            
                if err == nil {
                    
                let img = UIImage(data: data!)!
                self.showcaseImg.image = img
                    FeedVC.imgCache.setObject(img, forKey: self.post.imageURL!)
                    
                
                }else{
                    print("Error fetching image: \(err)")
                    }
                
               })
                
                
            }
        }else{
            self.showcaseImg.hidden = true

        }
        
        
           
                request2 = Alamofire.request(.GET, post.profileImgUrl).validate(contentType: ["image/*"]).response(completionHandler: {request, response, data, err in
                    
                    if err == nil {
                        
                        let profImg = UIImage(data: data!)!
                        self.profileImg.image = profImg
                        FeedVC.imgCache.setObject(profImg, forKey: self.post.profileImgUrl)
                        
                        
                    }else{
                        print("Error fetching profile image: \(err.debugDescription)")
                        print("End of profile error msg")
                    }
                    
                })
                
                
            
        

       
        
        likeRef.observeSingleEventOfType(.Value, withBlock:{snapshot in
        
            //check for NSNull in Firebase - NSNull will be returned if there is no value - not nil
            if let doesNotExist = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "hollowheart")
                
            }else{
               self.likeImage.image = UIImage(named: "fullheart")
            }
            
        })
        

}
    func likeTapped(sender: UITapGestureRecognizer) {
        likeRef.observeSingleEventOfType(.Value, withBlock:{snapshot in
            
            //check for NSNull in Firebase - NSNull will be returned if there is no value - not nil
            if let doesNotExist = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "fullheart")
                self.post.adjustLikes(true)
                self.likeRef.setValue(true)
                
            }else{
                self.likeImage.image = UIImage(named: "hollowheart")
                self.post.adjustLikes(false)
                self.likeRef.removeValue()
            }
            
        })

        
    }
    
    @IBAction func facebookShareTapped(sender: AnyObject) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Share on Facebook")
        
            //facebookSheet.addImage(showcaseImg.image)
         var url = NSURL(fileURLWithPath: "http://www.van-halen.com")
            facebookSheet.addURL(url)
            parentVC.presentViewController(facebookSheet,animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            parentVC.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}