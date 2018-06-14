//
//  EnterViewController.swift
//  vkProject
//
//  Created by Антон Григорьев on 09.04.2018.
//  Copyright © 2018 Антон Григорьев. All rights reserved.
//

//HELLO PEOPLE :)

import UIKit

class EnterViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Delay to prevent some problems
        if (!appDelegate.enterDelay) {
            delay(1.0, closure: {
            })
        } else {
            
        }
        self.continueLogin()
    }
    
    func goToLogin() {
        self.performSegue(withIdentifier: "LoginSegue", sender: self)
    }
    
    
    func goToApp() {
        self.performSegue(withIdentifier: "AppSegue", sender: self)
    }
    
}

extension EnterViewController: VkLoginDelegate {
    
    /*
     Checking if there current user. If yes - open friends controller.
     If no - we need to log in.
     */
    func continueLogin() {
        appDelegate.enterDelay = false
        
        
        if User.currentUser == nil {
            self.goToLogin()
        } else {
            self.goToApp()
        }
        
    }
    
    
}

