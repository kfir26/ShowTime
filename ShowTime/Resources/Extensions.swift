//
//  Extensions.swift
//  ShowTime
//
//  Created by כפיר פנירי on 17/06/2020.
//  Copyright © 2020 Kfir & ShowTime. All rights reserved.
//

import UIKit
import TextFieldEffects
import ChameleonFramework

extension UIView{
    
    public var width: CGFloat {
               return frame.size.width
           }

           public var height: CGFloat {
               return frame.size.height
           }

           public var top: CGFloat {
               return frame.origin.y
           }

           public var bottom: CGFloat {
               return frame.size.height + frame.origin.y
           }

           public var left: CGFloat {
               return frame.origin.x
           }

           public var right: CGFloat {
               return frame.size.width + frame.origin.x
           }

       
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor? ,right: NSLayoutXAxisAnchor? ,paddingTop:CGFloat ,paddingLeft: CGFloat, paddingBottom:CGFloat , paddingRight:CGFloat, width:CGFloat , height:CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
       
        if let top = top{
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }

        if let left = left{
                   self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
               }

        if let bottom = bottom{
                   self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
               }

        if let right = right{
                   self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
               }

        if width != 0 {
                   self.widthAnchor.constraint(equalToConstant: width).isActive = true
               }

        if height != 0 {
                   self.heightAnchor.constraint(equalToConstant: height).isActive = true
               }

    }
    
    func textContainerView(view: UIView, _ image: UIImage, _ textField: UITextField)-> UIView{
        view.backgroundColor = .clear
        let imageView =  UIImageView()
        imageView.image = image
        imageView.alpha = 0.87
        view.addSubview(imageView)
        imageView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 24, height: 24)
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(textField)
        textField.anchor(top: nil, left: imageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        textField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 1, alpha: 0.87)
        view.addSubview(separatorView)
        separatorView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.75)
        
        return view
    }
    
}
extension Notification.Name {
    /// Notificaiton  when user logs in
    static let didLogInNotification = Notification.Name("didLogInNotification")
}

extension UIColor{
    static func rgb(red: CGFloat , green: CGFloat , blue:CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        
        
    }
    
    static func mainBlue()-> UIColor{
        return UIColor.rgb(red: 0, green: 155, blue:255)
    }
}

extension UITextField{
    func textField(withPlaceolder placholder: String , isSecureTextEntry: Bool) -> UITextField{
        let tf = KaedeTextField()
        tf.placeholderColor = .white
        //tf.foregroundColor = .orange
        tf.keyboardAppearance = .dark
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.returnKeyType = .done
        tf.layer.cornerRadius = 12
        //tf.layer.borderWidth = 1
        //tf.layer.borderColor = UIColor.lightGray.cgColor
        //tf.placeholder = "Type here . . ."
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 26, weight: .semibold)

        tf.textColor = .white
        tf.isSecureTextEntry = isSecureTextEntry
        tf.attributedPlaceholder = NSAttributedString(string: placholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        return tf
    }
}
/*
/////////////////////////////////////////////////////////////
       MARK:  MY View Design CODES!  ---> ----->  -------->

// MARK: Gradient -->

1) HARD CODE:
let colors:[UIColor] = [
  UIColor.flatMint(),
  UIColor.flatLime()]

view.backgroundColor = UIColor(gradientStyle: UIGradientStyle.leftToRight,withFrame: view.frame,andColors: colors)

2) Func CODE:
func MyViewStyle(){
    let colors:[UIColor] = [
      UIColor.flatMint(),
      UIColor.flatMaroonColorDark()]
    
    view.backgroundColor = UIColor(gradientStyle: UIGradientStyle.radial,withFrame: view.frame,andColors: colors)
}

3) GRADIENT OPTIONS:
LeftToRight (UIGradientStyle.LeftToRight in Swift)
TopToBottom (UIGradientStyle.TopToBottom in Swift)
Radial (UIGradientStyle.Radial in Swift)
////////////////////////////////////////////////

// MARK: ShimmeringView -->
 1) HARD CODE:
let shimmerView = ShimmeringView(frame: CGRect(x: 30, y: 300, width: view.frame.size.width-60, height: 60))
view.addSubview(shimmerView)
shimmerView.contentView = loginbutton
shimmerView.isShimmering = true
///////////////////////////////////////////////////
*/






