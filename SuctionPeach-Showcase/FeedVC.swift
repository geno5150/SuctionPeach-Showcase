//
//  FeedVC.swift
//  SuctionPeach-Showcase
//
//  Created by Geno Erickson on 12/23/15.
//  Copyright © 2015 SuctionPeach. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import Social

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate     {
    
    var posts = [Post]()
    static var imgCache = NSCache()
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postField: MaterialTextField!
    @IBOutlet weak var imageSelectorCamera: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var fbShareButton: MaterialButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //PostCell.parentVC = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 358
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            self.posts = []
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    print("snap: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject>{
                    let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
                    
                
            }
                self.tableView.reloadData()
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell{
            cell.request?.cancel()
            var img: UIImage?
            if let url = post.imageURL {
               img = FeedVC.imgCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(post, img: img, upperVC: self)
            return cell
            
        }else{
            return PostCell()
            
        }
        
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        if post.imageURL == nil{
            return 200
        }else{
            return tableView.estimatedRowHeight
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
            imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageSelectorCamera.image    = image
        imageSelected = true
    
    }
    @IBAction func selectImage(sender: AnyObject) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    @IBAction func makePost(sender: AnyObject) {
        if let txt = postField.text where txt != ""{
         
            if let img = imageSelectorCamera.image where imageSelected == true {
                let urlStr = "https://post.imageshack.us/upload_api.php"
                let url = NSURL(string: urlStr)!
                let imgData = UIImageJPEGRepresentation(img, 0.2)!
                let keyData = "045KLMOX4f76490d90ac2207259abf3cb8f7bb7a".dataUsingEncoding(NSUTF8StringEncoding)!
                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                Alamofire.upload(.POST, url, multipartFormData: { multipartFormData  in
                    
                    multipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
                    multipartFormData.appendBodyPart(data: keyData, name: "key")
                    multipartFormData.appendBodyPart(data: keyJSON, name: "format")
                    }) {encodingResult  in
                        switch encodingResult {
                            
                                case .Success(let upl, _, _):
                                upl.responseJSON(completionHandler: { request in
                                    print("Result: \(request.result)")
                                  
                                if let info = request.result.value as? Dictionary<String, AnyObject>{
                                    if let links = info["links"] as? Dictionary<String, AnyObject>{
                                        if let imgLink = links["image_link"] as? String {
                                            self.postToFirebase(imgLink)
                                        }
                                    }
                                }
                            })
                        case .Failure(let error):
                            print(error)
                        }
            
                }
                
            }else{
                
                self.postToFirebase(nil)
            }
        
        }
    
    }
    
    func postToFirebase(imgUrl: String?){
        var post: Dictionary<String, AnyObject> = [
        "description": postField.text!,
        "likes": 0,
        "profileImgUrl": FB_PROFILE_URL,
        "firstName": FB_FIRST_NAME]
        
        if imgUrl != nil{
        post["imageURL"] = imgUrl
        }
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        postField.text = ""
        imageSelectorCamera.image = UIImage(named: "camera-outline")
        imageSelected = false
        
        tableView.reloadData()
    }
}
