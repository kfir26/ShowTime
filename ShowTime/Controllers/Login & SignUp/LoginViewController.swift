//
//  LoginViewController.swift
//  ShowTime
//
//  Created by כפיר פנירי on 17/06/2020.
//  Copyright © 2020 Kfir & ShowTime. All rights reserved.


//SwiftUI importing make to show my controller in real Time
//import SwiftUI

import UIKit
import FirebaseAuth
import Firebase
import ShimmerSwift
import ChameleonFramework
import JGProgressHUD
import TextFieldEffects
import Hero

class LoginViewController: UIViewController {

    ///////////////// MARK: Make the Spinner
    private let spinner = JGProgressHUD(style: .dark)
    
                                 ////////////////////////////////////////
    
    let logoImageView : UIImageView = {
         let iv = UIImageView()
         iv.contentMode = .scaleAspectFit
         iv.clipsToBounds = true
         iv.image = UIImage(named: "icons8-jetpack_joyride")
         return iv
     }()
    lazy var emailContainerView: UIView = {
        let view = UIView()
        return view.textContainerView(view: view, #imageLiteral(resourceName: "email-filled"),emailTextField)
    }()
    lazy var passwordContainerView: UIView = {
        let view = UIView()
        return view.textContainerView(view: view, #imageLiteral(resourceName: "lock-filled"),passwordTextField)
    }()
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceolder: "Email", isSecureTextEntry:false)
    }()
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceolder: "Password", isSecureTextEntry:true)
    }()
    let loginButton: UIButton = {
        let button  = UIButton(type: .system)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.flatWatermelon()
        button.addTarget(self, action: #selector(LoginTapped), for: .touchUpInside)
        button.layer.cornerRadius = 28
        return button
    }()
    
    let dontHaveAccounetButton: UIButton = {
        let button  = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't Have an Account Yet?   ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Sign UP", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]) )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
                
        let shimmerView = ShimmeringView(frame: CGRect(x: 30, y: 370, width: view.frame.size.width-60, height: 60))
        view.addSubview(shimmerView)
        shimmerView.contentView = loginButton
        shimmerView.shimmerSpeed  = 100
        shimmerView.isShimmering = true
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableHero()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disableHero()
    }

    ////////////////////
    private var loginObserver: NSObjectProtocol?
                        ///////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ////////////////////////////////
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main, using: { [ weak self] _ in
            guard let strongSelf = self else{
                return
            }
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
        //////////////////////
        configureViewComponents()
        
        // MARK: ADD Subviews
           view.addSubview(logoImageView)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    //////////////////////////////////
    deinit {
         if let observer = loginObserver {
             NotificationCenter.default.removeObserver(observer)
         }
     }
                ///////////////////////////////////////////////
    @objc func LoginTapped(){
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty , !password.isEmpty, password.count >= 6 else{
            alertUserLoginError()
            return
            
        }
        
        spinner.show(in: view)
        
        //MARK: Firebase Login
        Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] authResult,error in
            
            guard let strongself = self else{
                return
            }
            
            DispatchQueue.main.async {
                strongself.spinner.dismiss()

            }
            
            guard let result = authResult, error == nil else{
                print("Failed to log in user with email:  \(email)")
                return
            }
            
            let user = result.user
                        
            // MARK:REMEMBER ME HERE
            
            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            DatabaseManager.shared.getDataFor(path: safeEmail, completion: { result in
                switch result{
                case .success(let data):
                    guard let userData = data as? [String:Any],
                        let firstName = userData["first_name"] as? String,
                    let lastName = userData["last_name"] as? String else{
                        return
                    }
                    UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
                    
                case .failure(let error):
                    print("failed to read data !\(error)")
                }
            })
            
            UserDefaults.standard.set(email,forKey: "email")

            //MARK:CONNECTION
            // make the connection to HOME PAGE
            guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                else{return}

            guard let controller = navController.viewControllers[0] as? HomeViewController else{return}
            controller.configureViewComponents()
            
/*
             print("Logged in user: \(user)")
                     strongself.navigationController?.dismiss(animated: true, completion: nil)
             */

            print("Logged in user: \(user)")
            strongself.dismiss(animated: true, completion: nil)
        })
        
    }
    
    func alertUserLoginError(){
        let alert = UIAlertController(title: "Woops", message: "Please Enter all Info to Login . . .", preferredStyle: .alert)
        
        alert.addAction((UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)))
        
        present(alert,animated: true)
    }
    
    
    
    @objc func handleShowSignUp(){
//        let controller = RegisterViewController()
//        self.showHero(controller)
        
        navigationController?.pushViewController(RegisterViewController(), animated: true)
        print("Moved to SignUp")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        }
    

func MyViewStyle(){
    let colors:[UIColor] = [
      UIColor.flatMint(),
      UIColor.flatGreen()]

    view.backgroundColor = UIColor(gradientStyle: UIGradientStyle.topToBottom,withFrame: view.frame,andColors: colors)
}
    func configureViewComponents(){

        MyViewStyle()

        navigationController?.navigationBar.isHidden = true
        
        
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(emailContainerView)
        emailContainerView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(passwordContainerView)
        passwordContainerView.anchor(top: emailContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(loginButton)
        loginButton.anchor(top: passwordContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        
        view.addSubview(dontHaveAccounetButton)
        dontHaveAccounetButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 32, paddingBottom: 12, paddingRight: 32, width: 0, height: 50)
        
    }
    
}

extension LoginViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        
        else if textField == passwordTextField{
            LoginTapped()
        }
        
        return true
    }
    
}


extension UIColor{
    class func loginBtnColor() ->UIColor{
        return rgb(red: 106, green: 90, blue: 210)
    }
    
    class func newBtnColor() ->UIColor{
        return flatBlueColorDark()
    }
    
    
}

