//
//  NewPostViewController.swift
//  ShowTime
//
//  Created by כפיר פנירי on 23/06/2020.
//  Copyright © 2020 Kfir & ShowTime. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {

    @IBOutlet var shareButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!

    var textViewPlaceholderText = "Whats up?"
    
   //MARK: CAMERA
    var imagePicker: UIImagePickerController!
    var takenImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.layer.cornerRadius = shareButton.frame.height / 2
        
        view.sendSubviewToBack(postImageView)
        
        captionTextView.text = textViewPlaceholderText
        captionTextView.textColor = .systemIndigo
             captionTextView.delegate = self
        
        //SHOW THE CAMERA:
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
        }else{
            imagePicker.sourceType = .photoLibrary
            
        }
        
        self.present(imagePicker,animated: true,completion: nil)
    
    }
    
    @IBAction func shareDidTap(){
        //////////////////
        let viewController = ShareViewController(nibName: "ShareViewController", bundle: nil)
        present(viewController,animated: true)
        
        //////////////////
        if captionTextView.text != "" && captionTextView.text != textViewPlaceholderText && takenImage != nil{
            let newPost = Post(image: takenImage, caption: captionTextView.text)
            newPost.save()
            
            //self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelDidTap( _ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
extension NewPostViewController: UITextViewDelegate{
    func textBegainEditing(_ textView:UITextView){
        if textView.text == textViewPlaceholderText{
         textView.text = ""
            textView.textColor = .white
    }
        textView.becomeFirstResponder()
}
    
    func textEndEditing(_ textview: UITextView){
        if textview.text == ""{
            textview.text = textViewPlaceholderText
            //textview.textColor = .darkGray
        }
        
        textview.resignFirstResponder()
    }

}

extension NewPostViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.takenImage = image
        self.postImageView.image = self.takenImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}




