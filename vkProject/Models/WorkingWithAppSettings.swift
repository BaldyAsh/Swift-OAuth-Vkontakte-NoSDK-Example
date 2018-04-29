//
//  WorkingWithAppSettings.swift
//  vkProject
//
//  Created by Антон Григорьев on 13.04.2018.
//  Copyright © 2018 Антон Григорьев. All rights reserved.
//

import Foundation

class WorkingWithAppSettings {
    func setUserDefaults(usingUrl: String) {
        let data = usingUrl.components(separatedBy: CharacterSet.init(charactersIn: "&="))
        /*
         Parsing the following string:
         https://oauth.vk.com/blank.html#access_token=4e6ffd5ca0227599e9c1ef1828c3926a531503201d037108bee9357c110b5563d31f721cda84bbe4857a2&expires_in=0&user_id=163921411
         data[1] is access_token
         data[3] is expires_in
         data[5] is user_id
         */
        UserDefaults.standard.set(data[1], forKey: "access_token")
        UserDefaults.standard.set(data[3], forKey: "expires_in")
        UserDefaults.standard.set(data[5], forKey: "user_id")
    }
    
    func deleteUserDefaults(){
        UserDefaults.standard.removeObject(forKey: "access_token")
        UserDefaults.standard.removeObject(forKey: "expires_in")
        UserDefaults.standard.removeObject(forKey: "user_id")
    }
    
    func logoutFromCurrentAccount() {
        //remove current user and remove user defaults for user data
        User.currentUser = nil
        User.currentUser?.info.removeAll()
        deleteUserDefaults()
        
        //delete cookies to make logout correct
        let cookies = HTTPCookieStorage.shared.cookies
        for cookie in cookies! {
            if cookie.domain.range(of: "vk.com") != nil {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
}
