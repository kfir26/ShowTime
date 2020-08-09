//
//  ShareViewController.swift
//  ShowTime
//
//  Created by כפיר פנירי on 30/06/2020.
//  Copyright © 2020 Kfir & ShowTime. All rights reserved.
//

import UIKit
import Lottie

enum DownloadKeyFrame : CGFloat{
    case startProgress = 80
    case endProgress = 221
    case completion = 222
}

class ShareViewController: UIViewController {
    
    @IBOutlet weak var done: UILabel!
    
    @IBOutlet weak var progressAnimation: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressAnimation.backgroundColor = .clear
        startProgress()
        
    }
    
    private func startProgress(){
        progressAnimation.play(fromFrame: 0, toFrame: DownloadKeyFrame.startProgress.rawValue, loopMode: .none) {[weak self] (_) in
            self?.startShare()
            
        }
        
    }
    
    private func startShare(){
        progressAnimation.play(fromFrame: DownloadKeyFrame.startProgress.rawValue, toFrame: DownloadKeyFrame.endProgress.rawValue, loopMode: .none) {[weak self](_) in
            self?.endProgress()
            
        }
    }
    
    private func progress(to progress: CGFloat){
        let progressRange = DownloadKeyFrame.endProgress.rawValue - DownloadKeyFrame.startProgress.rawValue
        
        let progressFrame = progressRange*progress
        
        let currentFrame = progressFrame + DownloadKeyFrame.startProgress.rawValue
        
        progressAnimation.currentFrame = currentFrame
    }
    
    
    private func endProgress(){
        progressAnimation.play(fromFrame: DownloadKeyFrame.endProgress.rawValue, toFrame: DownloadKeyFrame.completion.rawValue, loopMode: .none) {(_) in
            self.done.isHidden = false
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            let storyboard = UIStoryboard(name: "ShowMustOn", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as? AnimateBoxViewController {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc,animated: true)
                    }
                }
            }
        }
    }

    
    

extension NewPostViewController{
    
    private func shareTapped(){
    if captionTextView.text != "" && captionTextView.text != textViewPlaceholderText && takenImage != nil{
               let newPost = Post(image: takenImage, caption: captionTextView.text)
               newPost.save()
        }
    }    
}

//extension ShareViewController{
//    private func moveToFeed(){
//
//    present(NewsFeedTableViewController(), animated: true)
//    }
//}




