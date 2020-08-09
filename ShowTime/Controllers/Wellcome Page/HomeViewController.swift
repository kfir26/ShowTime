//
//  HomeViewController.swift
//  ShowTime
//
//  Created by כפיר פנירי on 21/06/2020.
//  Copyright © 2020 Kfir & ShowTime. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase

class HomeViewController: UIViewController {
    
    var info = [ProfileViewModel]()

    //MARK - Properties
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()

    //MARK - Init
    override func viewDidLoad() {
    authenticateUserAndConfigureView()
 }

    //MARK - Api
    func loadUserData(){
        //MARK: Making The Name & LastName To Welcome U
        let welcome = UserDefaults.standard.value(forKey:"name") as? String ?? "No Name"
        Database.database().reference().child(welcome).observeSingleEvent(of: .value) { (snapshot) in
            self.welcomeLabel.text = "Welcome, \(welcome)"

            UIView.animate(withDuration: 0.5, animations: {
                self.welcomeLabel.alpha = 1
            })
        }
    }

    func signOut(){
        do{
            try Auth.auth().signOut()
            // Router / prepareForSegue
            let navController = UINavigationController(rootViewController: LoginViewController())
            navController.navigationBar.barStyle = .black
            ////////////////////
            navigationController?.modalPresentationStyle = .fullScreen
                       ////////////////////////////////
            self.present(navController, animated: true, completion: nil)
        }catch let err{
            print("Faild to sign out with error...", err)
        }
    }

    func authenticateUserAndConfigureView(){
        if Auth.auth().currentUser == nil{
            // Router / prepareForSegue
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: LoginViewController())
                navController.navigationBar.barStyle = .black
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
                }
        }else{
            // loadUserData()
            configureViewComponents()
        }
    }

    // MARK - Selectors
    @objc func handleSignOut(){
        let alertController = UIAlertController(title: nil, message: "Are u Sure U wanna SignOut?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true,completion: nil)
    }

    func MyViewStyle(){
        let colors:[UIColor] = [
          UIColor.flatMint(),
          UIColor.flatGreen()]
        view.backgroundColor = UIColor(gradientStyle: UIGradientStyle.topToBottom,withFrame: view.frame,andColors: colors)
    }

    //MARK - HelperFunction
    func configureViewComponents(){

        MyViewStyle()
        welcomeLabel.text = ""
        navigationItem.title = "LOGOUT . . . "
        // SHOW THE ARROW TO SIGNOut after Welcoming The User:
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-left_filled"), style: .plain, target: self, action: #selector(handleSignOut))
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor.flatMint()

        view.addSubview(welcomeLabel)
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        loadUserData()
          //TIMER THAT TRANSPORT BETWEEN BOTH STORYBOARDS:
            //(From: Login+Register ---> to... ---> TO:  Main)
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
            print("Timer init")
            let storyboard = UIStoryboard(name: "ShowMustOn", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as? AnimateBoxViewController {
                vc.modalPresentationStyle = .fullScreen
                print("VC init")
                self.present(vc, animated: true){
                }
            }
        }
    }
}
extension UIColor{

    class func newTitleColor() ->UIColor{
        return flatBlueColorDark()
    }

}




