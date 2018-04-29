//
//  ProfileViewController.swift
//  vkProject
//
//  Created by Антон Григорьев on 16.04.2018.
//  Copyright © 2018 Антон Григорьев. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 76/255, green: 117/255, blue: 163/255, alpha: 1.0)
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Профиль"
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUserProfile()
    }
    
    /*
     Get user account and remember it.
     After finishing - display name and avatar.
     */
    func getUserProfile() {
        
        VKClient().getUserAccount { (user, error) in
            DispatchQueue.main.async {
                if user != nil {
                    // Place user in the currentUser
                    User.currentUser = user
                    
                    self.userName.text = User.currentUser?.fullname()
                    self.getAvatar()
                    
                } else {
                    self.getUserProfile()
                }
            }
            
        }
    }
    
    func getAvatar(){
        VKClient().getAvatar100(forUser: User.currentUser!, callback: { (imageData, error) in
            DispatchQueue.main.async {
                if imageData != nil {
                    self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.width / 2
                    self.userAvatar.clipsToBounds = true
                    let image = UIImage(data: imageData!)
                    self.userAvatar.image = image
                }
            }
        })
    }

    /*
     Logout only if network is available to prevent errors
    */
    @IBAction func logout(_ sender: UIButton) {
        
        if NetworkConnection().isInternetAvailable() {
            WorkingWithAppSettings().logoutFromCurrentAccount()
            
            //after removing app user settings go to enter controller
            let strbrd: UIStoryboard = self.storyboard!
            let enterController: EnterViewController = strbrd.instantiateViewController(withIdentifier: "EnterViewController") as! EnterViewController
            self.show(enterController, sender: self)
        } else {
            let alert = UIAlertController(title: "Network is unreachable",
                                          message: "Try next time",
                preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close",
                                          style: UIAlertActionStyle.default,
                                          handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
}
