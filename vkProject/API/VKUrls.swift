//
//  VKUrls.swift
//  vkProject
//
//  Created by Антон Григорьев on 13.04.2018.
//  Copyright © 2018 Антон Григорьев. All rights reserved.
//

import Foundation

class VKUrls {
    
    var defaults = UserDefaults.standard
    
    private let api = "https://api.vk.com"
    private let clientID = "6443086"
    private let redirect_uri = "&redirect_uri=https://oauth.vk.com/blank.html"
    private let display = "&display=page"
    private let scope = "&scope=friends,photos,offline"
    private let response_type = "&response_type=token"
    private let token_v = "&v=5.52"
    private var user_id = "user_id="
    private var access_token = "&access_token="
    private let fieldsUser = "&fields=photo_50,photo_max_orig,photo_100"
    private var orderFriends = "&order=name"
    private let fieldsFriends = "&fields=photo_50"
    
    func returnURL(task: task, addition: String?) -> URL {
        if let id = defaults.string(forKey: "user_id") {
            user_id = user_id + id
        }
        if let token = defaults.string(forKey: "access_token") {
            access_token = access_token + token
        }
        switch task {
        case .login:
            return URL(string: task.rawValue+clientID+display+redirect_uri+scope+response_type+token_v)!
        case .usersGet:
            if (addition != nil) {
                user_id = "user_id=" + addition!
                return URL(string: api+task.rawValue+user_id+fieldsUser+access_token+token_v)!
            } else {
               return URL(string: api+task.rawValue+user_id+fieldsUser+access_token+token_v)!
            }
            
        case .friendsGet:
            return URL(string: api+task.rawValue+user_id+orderFriends+fieldsFriends+access_token+token_v)!
        }
    }
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    
    enum task: String {
        case login = "https://oauth.vk.com/authorize?client_id="
        case usersGet = "/method/users.get?"
        case friendsGet = "/method/friends.get?"
    }
}
