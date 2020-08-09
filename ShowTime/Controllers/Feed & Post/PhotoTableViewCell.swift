//
//  PhotoTableViewCell.swift
//  ShowTime
//
//  Created by כפיר פנירי on 23/06/2020.
//  Copyright © 2020 Kfir & ShowTime. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class PhotoTableViewCell: UITableViewCell {
    

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post: Post!{
        didSet{
            self.updateUI()
        }
    }

    
    func updateUI(){
        
        //CAPTION
        self.captionLabel.text = post.caption
        print("here im!!!!!!!!!!!!")
        
        //DOWNLOAD IMAGES
        if let imageDownloadUrl = post.imageDownloadURL{
            // 1. create a storage referance
            let imageStorageRef = Storage.storage().reference(forURL: imageDownloadUrl)
            // 2.observe method to download the data
            imageStorageRef.getData(maxSize: 2 * 1024 * 1024) {[weak self]
                (data, error) in
                if let error = error{
                   print("******** ERROR DOWNLOADING IMAGE: \(error)")
               }else{
                    //SUCCESS
                    if let imageData = data{
                        DispatchQueue.main.async {
                           // 3.put the image to imageView
                             let image = UIImage(data: imageData)
                            self?.postImageView.image = image
                        }
                    }
                }
            }
        }
    }
}

