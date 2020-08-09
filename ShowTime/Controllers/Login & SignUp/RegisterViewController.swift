//
//  RegisterViewController.swift
//  ShowTime
//
//  Created by כפיר פנירי on 17/06/2020.
//  Copyright © 2020 Kfir & ShowTime. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import ChameleonFramework
import ShimmerSwift
import JGProgressHUD
import Hero

class RegisterViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableHero()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disableHero()
    }
    
     ///////////////// MARK: Make the Spinner
           private let spinner = JGProgressHUD(style: .dark)
                                        ////////////////////////////////////////
    
     let logoImageView : UIImageView = {
          let iv = UIImageView()
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.layer.cornerRadius = 40
          iv.contentMode = .scaleAspectFit
          iv.clipsToBounds = true
          iv.image = UIImage(named: "icons8-jetpack_joyride")
          return iv
      }()
    lazy var emailContainerView: UIView = {
         let view = UIView()
         return view.textContainerView(view: view, #imageLiteral(resourceName: "email-filled"),emailTextField)
     }()
     lazy var userNameContainerView: UIView = {
            let view = UIView()
            return view.textContainerView(view: view, #imageLiteral(resourceName: "profile-filled-2"),userNameTextField)
        }()
    lazy var lastNameContainerView: UIView = {
        let view = UIView()
        return view.textContainerView(view: view, #imageLiteral(resourceName: "profile-filled"),lastNameTextField)
    }()
     lazy var passwordContainerView: UIView = {
         let view = UIView()
         return view.textContainerView(view: view, #imageLiteral(resourceName: "lock-filled"),passwordTextField)
     }()
     lazy var phoneContainerView: UIView = {
           let view = UIView()
           return view.textContainerView(view: view, #imageLiteral(resourceName: "icons8-phone_filled"),phoneTextField)
       }()
     lazy var addressContainerView: UIView = {
           let view = UIView()
           return view.textContainerView(view: view, #imageLiteral(resourceName: "location-filled"),addressTextField)
       }()
    
    
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceolder: "Email", isSecureTextEntry:false)
    }()
    lazy var userNameTextField: UITextField = {
           let tf = UITextField()
           return tf.textField(withPlaceolder: "userName", isSecureTextEntry:false)
       }()
    lazy var lastNameTextField: UITextField = {
             let tf = UITextField()
             return tf.textField(withPlaceolder: "LastName", isSecureTextEntry:false)
         }()
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceolder: "Password", isSecureTextEntry:true)
    }()
    lazy var phoneTextField: UITextField = {
           let tf = UITextField()
           return tf.textField(withPlaceolder: "PhoneNumber", isSecureTextEntry:false)
       }()
    lazy var addressTextField: UITextField = {
           let tf = UITextField()
           return tf.textField(withPlaceolder: "Address", isSecureTextEntry:false)
       }()
     
     let signUpButton: UIButton = {
         let button  = UIButton(type: .system)
         button.layer.cornerRadius = 12
         button.layer.masksToBounds = true
         button.setTitle("SignUp", for: .normal)
         button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
         button.setTitleColor(.white, for: .normal)
         button.backgroundColor = UIColor.flatWatermelon()
         button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
         button.layer.cornerRadius = 28
         return button
     }()
     
     let dontHaveAccounetButton: UIButton = {
         let button  = UIButton(type: .system)
         let attributedTitle = NSMutableAttributedString(string: "Already Have an Account?   ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),NSAttributedString.Key.foregroundColor: UIColor.white])
         attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]) )
         button.setAttributedTitle(attributedTitle, for: .normal)
         button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
         return button
     }()
    
    ///////////////////////// Shimmering the signUpButton --->  viewDidApper ...
    override func viewDidAppear(_ animated: Bool) {
        let shimmerView = ShimmeringView(frame: CGRect(x: 30, y: 620, width: view.frame.size.width-60, height: 60))
         view.addSubview(shimmerView)
         shimmerView.contentView =  signUpButton
        shimmerView.shimmerSpeed  = 100
         shimmerView.isShimmering = true
    }

     override func viewDidLoad() {
         super.viewDidLoad()

         configureViewComponents()
         
//         navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector (didTapRegister))
        
         // MARK: ADD Subviews
         
         emailTextField.delegate = self
         passwordTextField.delegate = self
         
     }
     
     @objc func handleSignUp(){
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        //phoneTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        userNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        
        
        guard let userName = userNameTextField.text,
            let lastName = lastNameTextField.text,
            let address = addressTextField.text,
            //let phone = phoneTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,

            !email.isEmpty,
            //!phone.isEmpty,
            !address.isEmpty,
            !userName.isEmpty,
            !lastName.isEmpty,
            !password.isEmpty,password.count >= 6
            
            
        
            else{
             alertUserLoginError()
             return
         }
        
        spinner.show(in: view)
         
         // MARK:Firebase Login
        DatabaseManager.shared.userExists(with: email, completion: {[weak self] exists in
            
            guard let strongself = self else{
                                  return
                              }
            
            DispatchQueue.main.async {
                strongself.spinner.dismiss()

            }
            
            guard !exists else{
                //user already exists
                strongself.alertUserLoginError(message: "Looks like user account for that email already exists . . .")
                return
            }
            Auth.auth().createUser(withEmail: email, password: password, completion: {authResult, error in
                
                
                guard  authResult != nil, error == nil else{
                    print("Error creating user")
                    return
                }
                //////////////////////
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set("\(userName) \(lastName)", forKey: "name")
                //////////////////////////////////
                
                let chatUser = ChatAppUser(firstName: userName, lastName: lastName, emailAddress: email)
                DatabaseManager.shared.insertUser(with:chatUser,completion: { success in
                    if success{
                        // upload image
                        guard let image  =
                            strongself.logoImageView.image, let data = image.pngData() else{
                                return
                        }
                        
                        
                        let fileName = chatUser.profilePictureFileName
                        StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName,completion:  { result in
                            switch (result){
                            case .success(let downloadUrl):
                                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                print(downloadUrl)
                            case.failure(let error):
                                print("storage Manager error: \(error)")
                            }
                        })
                    }
                })
                
                guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                    else{return}
                
                guard let controller = navController.viewControllers[0] as? HomeViewController else{return}
                controller.configureViewComponents()
                
                strongself.dismiss(animated: true, completion: nil)
                print("Successfully sign up...")
                
//                  strongself.navigationController?.dismiss(animated: true, completion: nil)
              })
        })
     }
     
    func alertUserLoginError(message: String = "Please Enter all Info to create a new account . . ."){
         let alert = UIAlertController(title: "Woops", message: message, preferredStyle: .alert)
         
         alert.addAction((UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)))
            present(alert,animated: true)
     }

     @objc func handleShowLogin(){
        let controller = LoginViewController()
        self.logoImageView.heroID = "logo"
        controller.logoImageView.heroID = "logo"
        self.showHero(controller) //navigationController?.popViewController(animated: true)
    }
    
    func MyViewStyle(){
        let colors:[UIColor] = [
            UIColor.flatMint(),
            UIColor.flatGreen()]
        
        view.backgroundColor = UIColor(gradientStyle: UIGradientStyle.topToBottom,withFrame: view.frame,andColors: colors)
    }
    
    @objc private func didTapChangeProfilePic(){
        presentPhotoActionSheet()
    }
    
    
    // MARK: Helpers:
        
        func configureViewComponents(){
            MyViewStyle()
            navigationController?.navigationBar.isHidden = true
            
            view.addSubview(logoImageView)
            ///////////////////////////////////******************
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
            logoImageView.addGestureRecognizer(gesture)
            
            logoImageView.isUserInteractionEnabled = true
            /////////////////////************************************
            logoImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            view.addSubview(userNameContainerView)
            userNameContainerView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
            
           view.addSubview(lastNameContainerView)
            lastNameContainerView.anchor(top: userNameContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
            /////
            view.addSubview(emailContainerView)
                     emailContainerView.anchor(top: lastNameContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
            
            view.addSubview(passwordContainerView)
                     passwordContainerView.anchor(top: emailContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
            
            view.addSubview(addressContainerView)
                     addressContainerView.anchor(top: passwordContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
            
            view.addSubview(signUpButton)
            signUpButton.anchor(top: addressContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 12, paddingRight: 32, width: 0, height: 50)
            
            view.addSubview(dontHaveAccounetButton)
            dontHaveAccounetButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)

            
        }
        
        
    }


extension RegisterViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "how would u like to select a picture", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
        
        actionSheet.addAction(UIAlertAction(
        title: "Take Photo",
        style: .default,
        handler: { [weak self]_ in
            self?.presentCamera()
    }))
        actionSheet.addAction(UIAlertAction(
        title: "Choose Photo",
        style: .default,
        handler: { [weak self]_ in
            self?.presentPhotoPicker()
    }))
        present(actionSheet,animated: true)
}
    
    func presentCamera(){
       let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print(info)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            else{return}
        self.logoImageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
extension RegisterViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        
        else if textField == passwordTextField{
            handleSignUp()
        }
        
        return true
    }
    
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


