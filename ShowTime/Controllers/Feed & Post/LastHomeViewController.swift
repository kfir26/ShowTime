//
//  LastHomeViewController.swift
//  ShowTime
//
//  Created by כפיר פנירי on 29/06/2020.
//  Copyright © 2020 Kfir & ShowTime. All rights reserved.
//

import UIKit
import Lottie

class LastHomeViewController: UIViewController {

    @IBOutlet var HappyAnimation: AnimationView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HappyMeAnimation()
    }
    
    func HappyMeAnimation(){
        HappyAnimation.frame = view.bounds
        HappyAnimation.animation = Animation.named("8134-dont-worry-be-happy")
        HappyAnimation.loopMode = .loop
        HappyAnimation.play()
        HappyAnimation.contentMode = .scaleAspectFill
        
    }

    
    


}
