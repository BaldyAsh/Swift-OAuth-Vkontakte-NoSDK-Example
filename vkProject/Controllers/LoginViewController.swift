//
//  LoginViewController.swift
//  ProjectTest
//
//  Created by Антон Григорьев on 10.04.2018.
//  Copyright © 2018 Антон Григорьев. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var buttonContainerView: UIView!
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var logoVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoMovingToTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightStartConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightEndConstraint: NSLayoutConstraint!
    
    private let vkWebView = UIWebView()
    
    private let animation = AnimationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonContainerView.layer.cornerRadius = 5
        buttonContainerView.alpha = 0
        greetingsLabel.alpha = 0
        
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        WorkingWithAppSettings().deleteUserDefaults()
        
        
        //Logo animation
        logoVerticalCenterConstraint.isActive = false
        logoMovingToTopConstraint.isActive = true
        logoHeightStartConstraint.isActive = false
        logoHeightEndConstraint.isActive = true
        
        UIView.animate(withDuration: 1.5) {
            self.view.layoutIfNeeded()
            self.buttonContainerView.alpha = 1
            self.greetingsLabel.alpha = 1
            self.buttonContainerView.frame.offsetBy(dx: 0, dy: -20)
            self.greetingsLabel.frame.offsetBy(dx: 0, dy: -20)
            
            
        }
        
    }
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        //dismiss animation and close web views just in case of error 999
        self.animation.waitAnimation(isEnabled: false, notificationText: nil, selfView: self.vkWebView)
        self.closeWebView()
        
        //creating webView
        self.vkWebView.scalesPageToFit = true
        self.vkWebView.tag = 1024 //tag for web view
        self.vkWebView.delegate = self
        self.view.addSubview(vkWebView)
        self.vkWebView.becomeFirstResponder()
        self.vkWebView.translatesAutoresizingMaskIntoConstraints = false
        let leftWebViewConstraint = NSLayoutConstraint(item: self.vkWebView,
                                                       attribute: NSLayoutAttribute.left,
                                                       relatedBy: NSLayoutRelation.equal,
                                                       toItem: self.view,
                                                       attribute: NSLayoutAttribute.left,
                                                       multiplier: 1,
                                                       constant: 0)
        let rightWebViewConstraint = NSLayoutConstraint(item: self.vkWebView,
                                                        attribute: NSLayoutAttribute.right,
                                                        relatedBy: NSLayoutRelation.equal,
                                                        toItem: self.view,
                                                        attribute: NSLayoutAttribute.right,
                                                        multiplier: 1,
                                                        constant: 0)
        let topWebViewConstraint = NSLayoutConstraint(item: self.vkWebView,
                                                      attribute: NSLayoutAttribute.top,
                                                      relatedBy: NSLayoutRelation.equal,
                                                      toItem: self.view,
                                                      attribute: NSLayoutAttribute.top,
                                                      multiplier: 1,
                                                      constant: UIApplication.shared.statusBarFrame.height)
        let bottomWebViewConstraint = NSLayoutConstraint(item: self.vkWebView,
                                                         attribute: NSLayoutAttribute.bottom,
                                                         relatedBy: NSLayoutRelation.equal,
                                                         toItem: self.view,
                                                         attribute: NSLayoutAttribute.bottom,
                                                         multiplier: 1,
                                                         constant: 0)
        
        self.view.addConstraints([leftWebViewConstraint,
                             rightWebViewConstraint,
                             topWebViewConstraint,
                             bottomWebViewConstraint])
        //start wait animation
        self.animation.waitAnimation(isEnabled: true, notificationText: "Loading login page", selfView: self.vkWebView)
        
        //creating request
        let loginRequest = VKClient().login()
        //loading request in webvView
        self.vkWebView.loadRequest(loginRequest)
        
        //close button for webview
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: UIScreen.main.bounds.width-35,
                                   y: 10,
                                   width: 20,
                                   height: 20)
        closeButton.tag = 1025
        closeButton.addTarget(self, action: #selector(closeWebView), for: .touchUpInside)
        closeButton.setTitle("x", for: .normal)
        closeButton.titleLabel?.font = UIFont(name: "Arial", size: 40)
        self.vkWebView.addSubview(closeButton)
        
    }
    
    @objc func closeWebView (){
        self.view.viewWithTag(1024)?.removeFromSuperview()
        self.view.viewWithTag(1025)?.removeFromSuperview()
    }
    
    /*
     Get user account and remember it.
     After finishing - open enter screen.
     */
    func goToApp(alert: UIAlertAction?) {
        
        VKClient().getUserAccount { (user, error) in
            DispatchQueue.main.async {
                if user != nil {
                    
                    self.dismiss(animated: true, completion: {
                        // Place user in the currentUser
                        User.currentUser = user
                    })
                } else {
                    let alert = UIAlertController(title: "Can't load user info",
                                                  message: error!,
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    let tryAccessUserAccountInfoAction = UIAlertAction(title: "Try again", style: .default, handler: self.goToApp)
                    alert.addAction(tryAccessUserAccountInfoAction)
                    alert.addAction(UIAlertAction(title: "Try login again",
                                                  style: UIAlertActionStyle.default,
                                                  handler: nil))
                    self.present(alert, animated: true, completion: nil)

                }
            }
            
        }
        
    }
    
}


extension LoginViewController: UIWebViewDelegate, URLSessionDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        //dismiss animation when loading page finished
        self.animation.waitAnimation(isEnabled: false, notificationText: nil, selfView: self.vkWebView)
        
        //check adress
        let currentURL = webView.request?.url?.absoluteString
        var textRange: Range? = (currentURL?.lowercased().range(of: "access_token"))
        
        //check token info
        if(textRange != nil ){
            //set data
            WorkingWithAppSettings().setUserDefaults(usingUrl: currentURL!)
            
            //for not going to have enter delay
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.enterDelay = true
            
            //close web view and start getting user account info - after which we will continue with friends controller
            self.closeWebView()
            self.goToApp(alert: nil)
            
        }
        else {
            textRange = currentURL?.lowercased().range(of: "access_denied")
            if (textRange != nil) {
                let alert = UIAlertController(title: "Access denied",
                                              message: "Check your internet connection",
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close",
                                              style: UIAlertActionStyle.default,
                                              handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.closeWebView()
            }
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        //error when we close web view before loading page - after that we will get error 999. To prevent it I check error.localizedDescription and if it's it - return
        if (error.localizedDescription == "The operation couldn’t be completed. (NSURLErrorDomain error -999.)"){
            return
        }
        
        let alert = UIAlertController(title: "Can't load page",
                                      message: "Error: \(error.localizedDescription)",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close",
                                      style: UIAlertActionStyle.default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        self.animation.waitAnimation(isEnabled: false, notificationText: nil, selfView: self.vkWebView)
        self.closeWebView()
    }
    
}

