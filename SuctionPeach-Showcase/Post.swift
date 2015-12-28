//
//  Post.swift
//  SuctionPeach-Showcase
//
//  Created by Geno Erickson on 12/23/15.
//  Copyright © 2015 SuctionPeach. All rights reserved.
//

import Foundation
import Firebase
class Post {
    
    private var _postDescription: String!
    private var _imageURL: String?
    private var _likes: Int!
    private var _username: String!
    private var _postkey: String!
    private var _postRef: Firebase!
    private var _profileImgUrl : String!
    private var _firstName: String!
    
    var postDescription: String?{
        return _postDescription
    }
    
    var imageURL: String? {
        return _imageURL
    }
    
    var likes: Int {
        return _likes
    }
    
    var username: String {
        return _username
    }
    var postKey: String {
        return _postkey
    }
    
    var firstName: String{
        return _firstName
    }
    
    var profileImgUrl: String {
        
         return _profileImgUrl
       
       
    }
    
    init(description: String, imageURL: String?, username: String){
        self._postDescription = description
        self._username = username
        self._imageURL = imageURL
        
    }
    init(postKey: String, dictionary: Dictionary<String, AnyObject>){
        self._postkey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let imgURL = dictionary["imageURL"] as? String{
    
            self._imageURL = imgURL
    
    }
        if let desc = dictionary["description"] as? String {
            self._postDescription = desc
        }
        if let profImg = dictionary["profileImgUrl"] as? String{
            self._profileImgUrl = profImg
        }
        if let fName = dictionary["firstName"] as? String {
            self._firstName = fName
        }
        self._postRef = DataService.ds.REF_POSTS.childByAppendingPath(self._postkey)
        
        
    }
    func adjustLikes(addLike: Bool){
        
        if addLike == true {
            _likes = _likes+1
        }else{
         _likes = _likes - 1
        }
        
        _postRef.childByAppendingPath("likes").setValue(_likes)
        
        
    }
}
