//
//  DocumentViewController.swift
//  vkProject
//
//  Created by Антон Григорьев on 15.04.2018.
//  Copyright © 2018 Антон Григорьев. All rights reserved.
//

import UIKit

class AvatarViewController: UIViewController {

    public var friendToGetAvatar: Person?
    private let vkWebView = UIWebView()
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private let animation = AnimationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        titleLabel.text = friendToGetAvatar?.fullname()
        
        //creating webView
        vkWebView.scalesPageToFit = true
        vkWebView.tag = 1024;
        vkWebView.delegate = self as UIWebViewDelegate;
        self.view.addSubview(vkWebView)
        vkWebView.becomeFirstResponder()
        vkWebView.translatesAutoresizingMaskIntoConstraints = false
        let leftWebViewConstraint = NSLayoutConstraint(item: vkWebView,
                                                       attribute: NSLayoutAttribute.left,
                                                       relatedBy: NSLayoutRelation.equal,
                                                       toItem: self.view,
                                                       attribute: NSLayoutAttribute.left,
                                                       multiplier: 1,
                                                       constant: 0)
        let rightWebViewConstraint = NSLayoutConstraint(item: vkWebView,
                                                        attribute: NSLayoutAttribute.right,
                                                        relatedBy: NSLayoutRelation.equal,
                                                        toItem: self.view,
                                                        attribute: NSLayoutAttribute.right,
                                                        multiplier: 1,
                                                        constant: 0)
        let topWebViewConstraint = NSLayoutConstraint(item: vkWebView,
                                                      attribute: NSLayoutAttribute.top,
                                                      relatedBy: NSLayoutRelation.equal,
                                                      toItem: self.navigationView,
                                                      attribute: NSLayoutAttribute.bottom,
                                                      multiplier: 1,
                                                      constant: 0)
        let bottomWebViewConstraint = NSLayoutConstraint(item: vkWebView,
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
        
        getFriendAccountInfo()
        
    }
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
     Get friend account info and use its avatar url we will start downloading avatars preview
     */
    func getFriendAccountInfo() {
        //start wait animation
        self.animation.waitAnimation(isEnabled: true, notificationText: "Loading avatar", selfView: self.vkWebView)
        
        VKClient().getFriendAccount(friend: friendToGetAvatar!, callback: { (friendInfo, error) in
            if friendInfo != nil {
                self.getFriendAvatarPreview(info: friendInfo!)
            } else {
                self.getFriendAccountInfo()
            }
        })
    }
    
    /*
     Show users avatar
     */
    func getFriendAvatarPreview(info: Person) {
        DispatchQueue.main.async {
            
            //creating request
            let getAvatarRequest = VKClient().loadPhotoRequest(withUrl: info.info["photo_max_orig"] as! String)
            //loading request in webvView
            self.vkWebView.loadRequest(getAvatarRequest)
        }
    }

}

extension AvatarViewController: UIWebViewDelegate, URLSessionDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        //dismiss animation when loading page finished
        self.animation.waitAnimation(isEnabled: false, notificationText: nil, selfView: self.view)
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        //dismiss animation when loading page finished
        self.animation.waitAnimation(isEnabled: false, notificationText: nil, selfView: self.view)
        
        getFriendAccountInfo()
    }
}
