//
//  LaunchScreen2ViewController.swift
//  ShowTime
//
//  Created by כפיר פנירי on 17/06/2020.
//  Copyright © 2020 Kfir & ShowTime. All rights reserved.
//

import UIKit
import Lottie
import ChameleonFramework

class LaunchScreen2ViewController: UIViewController {
    let animationView = AnimationView()

    @IBOutlet var launchNo2: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
    }
    
     override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        UIView.animate(withDuration: 5.2, animations:{
            self.launchNo2.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.size.height)
        }) {(success) in
             let sb = UIStoryboard(name: "Login+Register", bundle: nil)
            sb.instantiateInitialViewController()?.modalPresentationStyle = .fullScreen
            let vc = sb.instantiateInitialViewController()
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
        
    }
    func startAnimation(){
       animationView.frame = view.bounds
        animationView.backgroundColor = UIColor.flatMint()
       animationView.animation = Animation.named("4693-loading")
       animationView.contentMode = .scaleAspectFit
       animationView.loopMode = .loop
       animationView.play()
         view.addSubview(animationView)
                        
    }
    func MyViewStyle(){
           let colors:[UIColor] = [
             UIColor.flatMint(),
             UIColor.flatGreen()]
           
           view.backgroundColor = UIColor(gradientStyle: UIGradientStyle.topToBottom,withFrame: view.frame,andColors: colors)
       }

}

