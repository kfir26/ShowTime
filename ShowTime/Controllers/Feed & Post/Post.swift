//
//  Post.swift
//  ShowTime
//
//  Created by כפיר פנירי on 23/06/2020.
//  Copyright © 2020 Kfir & ShowTime. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class Post{
    var caption: String!
    var imageDownloadURL: String?
    private var image: UIImage!
    
    init(image:UIImage, caption:String) {
        self.image = image
        self.caption = caption
    }
    
    init(snapshot: DataSnapshot) {
        let json = JSON(snapshot.value)
        self.imageDownloadURL = json["imageDownloadURL"].stringValue
        self.caption = json["caption"].stringValue
    }
    
    
    func save(){
        //1. create new database ref
        let newPostRef = Database.database().reference().child("FeedPosts").childByAutoId()
        guard let newPostKey = newPostRef.key else {return}

        //2. create new storage ref
        if let imageData = self.image.jpegData(compressionQuality: 0.6){
            let imageStroageRef = Storage.storage().reference().child("FeedPhotos")
            let newImageRef = imageStroageRef.child(newPostKey)
            let imageDataType = StorageMetadata()
            imageDataType.contentType = "image/jpeg"
            //3. save the image to storage 1st
              newImageRef.putData(imageData,metadata: imageDataType).observe(.success ,handler:{(snapshot) in
                 //4. save the post caption & download url
                newImageRef.downloadURL { (url, err) in
                    self.imageDownloadURL = url?.absoluteString
                    let newPostDict = ["imageDownloadURL": self.imageDownloadURL,
                                       "caption" : self.caption]
                
                    newPostRef.setValue(newPostDict)
                }
            })

        }
        
    }
}
