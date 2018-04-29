//
//  User.swift
//  vkProject
//
//  Created by Антон Григорьев on 11.04.2018.
//  Copyright © 2018 Антон Григорьев. All rights reserved.
//

import Foundation

/*
 Current user class. Use it for login/logout
 */
class User: Person {
    
    //here contains current user
    static var _currentUser: User?
    
    /*
     Getter-setter to write into User Defaults current user or get info about it
     */
    class var currentUser: User? {
        get {
            
            if (_currentUser == nil) {
                // we get current user from UserDefaults and write to singleton
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUser") as? Data
                
                if let userData = userData {
                    let info = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! [String: Any?]
                    
                    _currentUser = User(info: info)
                }
            }
            return _currentUser
        }
        
        set(user) {
            //set user data into user defaults - here we can easily update user
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.info, options: [])
                defaults.set(data, forKey: "currentUser")
            } else {
                defaults.set(nil, forKey: "currentUser")
            }
        }
    }
    
}
