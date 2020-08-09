//
//  AnimateBoxViewController.swift
//  ShowTime
//
//  Created by כפיר פנירי on 21/06/2020.
//  Copyright © 2020 Kfir & ShowTime. All rights reserved.
//

import UIKit
import Lottie
import ChameleonFramework

class AnimateBoxViewController: UIViewController {

        let animationView = AnimationView()
        
        var swipeRightLabel: UILabel = {
            let label = UILabel()
            label.text = "Swipe Right To Present Time!"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 28)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.alpha = 1
            return label
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            startAnimation()
        }
    
    //THE AnimationView backgroundColor:
    func MyViewStyle(){
        let colors:[UIColor] = [
          UIColor.flatPowderBlue(),
          UIColor.flatMintColorDark()]

        animationView.backgroundColor = UIColor(gradientStyle: UIGradientStyle.radial,withFrame: view.frame,andColors: colors)
    }
    
        func startAnimation(){
            MyViewStyle()
            animationView.frame = view.bounds
            animationView.animation = Animation.named("18331-soona-surprise")
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
            view.addSubview(animationView)
            view.addSubview(swipeRightLabel)
            swipeRightLabel.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 32, paddingBottom: 12, paddingRight: 32, width: 0, height: 50)
     
        }
        
    }
