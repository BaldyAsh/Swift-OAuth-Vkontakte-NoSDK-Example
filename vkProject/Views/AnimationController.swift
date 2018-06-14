//
//  AnimationController.swift
//  vkProject
//
//  Created by Антон Григорьев on 10.04.2018.
//  Copyright © 2018 Антон Григорьев. All rights reserved.
//

import UIKit

class AnimationController: UIView {
    
    private enum AnimationViewTag: Int {
        case background = 1
        case notification = 2
        case activityIndicator = 3
    }
    
    private enum AnimationViewPositions: Int {
        case background = 100
        case notification = 101
        case activityIndicator = 102
    }
    
    /*
     Waiting animation for loading screens:
     isEnabled - true or false
     notificationText - text in the screens center
     selfView - superview for animation view
     */
    public func waitAnimation(isEnabled: Bool, notificationText: String?, selfView: UIView) {
        
        if (isEnabled) {
            
            selfView.alpha = 1.0
            
            let rect: CGRect = CGRect(x: 0,
                                      y: 0,
                                      width: UIScreen.main.bounds.size.width,
                                      height: UIScreen.main.bounds.size.height)
            let background: UIView = UIView(frame: rect)
            background.backgroundColor = UIColor.darkGray
            background.alpha = 0.5
            background.tag = AnimationViewTag.background.rawValue
            
            let notification: UILabel = UILabel.init(frame: CGRect(x: 0,
                                                                   y: 0,
                                                                   width: UIScreen.main.bounds.size.width,
                                                                   height: 15))
            notification.textColor = UIColor.white
            notification.textAlignment = NSTextAlignment.center
            notification.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
            notification.numberOfLines = 1
            
            let centerX = UIScreen.main.bounds.size.width/2
            let centerY = UIScreen.main.bounds.size.height/2
            
            notification.center = CGPoint(x: centerX+10, y: centerY+30)
            notification.tag = AnimationViewTag.notification.rawValue
            if (notificationText != nil) {
                notification.text = notificationText
            } else {
                notification.text = ""
            }
            
            
            let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
            var frame: CGRect = activityIndicator.frame
            frame.origin.x = centerX
            frame.origin.y = centerY
            frame.size.width = 20
            frame.size.height = 20
            activityIndicator.frame = frame
            activityIndicator.tag = AnimationViewTag.activityIndicator.rawValue
            
            selfView.insertSubview(background, at: AnimationViewPositions.background.rawValue)
            selfView.insertSubview(activityIndicator, at: AnimationViewPositions.activityIndicator.rawValue)
            selfView.insertSubview(notification, at: AnimationViewPositions.notification.rawValue)
            
            activityIndicator.startAnimating()
            
        } else {
            selfView.alpha = 1.0
            if let viewWithTag = selfView.viewWithTag(AnimationViewTag.background.rawValue) {
                viewWithTag.removeFromSuperview()
            }
            if let viewWithTag = selfView.viewWithTag(AnimationViewTag.notification.rawValue) {
                viewWithTag.removeFromSuperview()
            }
            if let viewWithTag = selfView.viewWithTag(AnimationViewTag.activityIndicator.rawValue) {
                viewWithTag.removeFromSuperview()
            }
        }
        
    }
    
    
}




