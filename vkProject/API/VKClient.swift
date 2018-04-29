//
//  VKClient.swift
//  vkProject
//
//  Created by Антон Григорьев on 11.04.2018.
//  Copyright © 2018 Антон Григорьев. All rights reserved.
//

import UIKit

class VKClient: NSObject, URLSessionDelegate, URLSessionTaskDelegate {
    
    var defaults = UserDefaults.standard
    /*
     Logic: Fetch request token -> redirect to auth -> fetch access token
    */
    
    /*
     Building session
     */
    lazy var connection: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: self as URLSessionDelegate, delegateQueue: nil)
        return session
    }()
    
    /*
     Get request token to open up auth link in web view
     returns URLRequest
     */
    func login() -> URLRequest {
        // create get request
        let url = VKUrls(defaults: defaults).returnURL(task: .login, addition: nil)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60000)
        request.httpMethod = "GET"
        
        return request
    }
    
    /*
     Get current users info
     escapes [Person]
     */
    func getUserAccount(callback: @escaping (User?, String?) -> Void) -> Void
    {
        let url = VKUrls(defaults: defaults).returnURL(task: .usersGet, addition: nil)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60000)
        request.httpMethod = "GET"
        
        let task = connection.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            //If there is any error
            if error != nil {
                callback(nil, error?.localizedDescription)
                
            } else {
                
                if (response as? HTTPURLResponse) != nil {
                    
                    //Checking if there any data
                    if data != nil {
                        //parse data and place it in the userDictionary
                        var userDictionary = [String: Any?]()
                        do {
                            //creating json from data
                            let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                            //if json contains "response" dictionary - go into it
                            if let response = json!["response"] as? [[String: Any]] {
                                //for each user in response get fields
                                for user in response {
                                    if let id = user["id"] as? Int {
                                        userDictionary["id"] = id
                                    }
                                    if let firstName = user["first_name"] as? String {
                                        userDictionary["first_name"] = firstName
                                    }
                                    if let lastName = user["last_name"] as? String {
                                        userDictionary["last_name"] = lastName
                                    }
                                    if let photo50 = user["photo_50"] as? String {
                                        userDictionary["photo_50"] = photo50
                                    }
                                    if let photo100 = user["photo_100"] as? String {
                                        userDictionary["photo_100"] = photo100
                                    }
                                    if let photoMaxOrig = user["photo_max_orig"] as? String {
                                        userDictionary["photo_max_orig"] = photoMaxOrig
                                    }
                                }
                            }
                            //create User obj
                            let user = User(info: userDictionary)
                            callback(user, nil)
                        } catch {
                            callback(nil,"Error deserializing JSON: \(error)")
                        }
                        
                        
                    } else {
                        callback(nil, "Data is corrupted")
                    }
                    
                } else {
                    callback(nil, "No response from server")
                }
            }
            
        })
        task.resume()
        
    }
    
    /*
     Get current users friends lists
     escapes [Person]
     */
    func getFriendsList(callback: @escaping ([Person]?, String?) -> Void) -> Void
    {
        
        var friendsList: [Person] = [Person(info: ["id": nil, "first_name": nil, "last_name": nil, "photo_50" : nil])]
        
        let url = VKUrls(defaults: defaults).returnURL(task: .friendsGet, addition: nil)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60000)
        request.httpMethod = "GET"
        
        let task = connection.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            //If there is any error
            if error != nil {
                callback(nil, error?.localizedDescription)
                
            } else {
                
                if (response as? HTTPURLResponse) != nil {
                    
                    //Checking if there any data
                    if data != nil {
                        do {
                            //creating json from data
                            let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                            //if json contains "response" field - go into it
                            if let response = json!["response"] as? [String: Any] {
                                //if "response" contains "items" dictionary - go into it
                                if let items = response["items"] as? [[String: Any]]{
                                    //if "item" in "items" dictionary get fields and place there values into itemDictionary
                                    for item in items {
                                        var itemDictionary = [String: Any?]()
                                        if let id = item["id"] as? Int {
                                            itemDictionary["id"] = id
                                        }
                                        if let firstName = item["first_name"] as? String {
                                            itemDictionary["first_name"] = firstName
                                        }
                                        if let lastName = item["last_name"] as? String {
                                            itemDictionary["last_name"] = lastName
                                        }
                                        if let photo50 = item["photo_50"] as? String {
                                            itemDictionary["photo_50"] = photo50
                                        }
                                        //create Person obj with itemDictionary - 1 friends
                                        let friend = Person(info: itemDictionary)
                                        //append friend to friends list
                                        friendsList.append(friend)
                                    }
                                }
                            }
                            friendsList.removeFirst()
                            callback(friendsList, nil)
                        } catch {
                            callback(nil,"Error deserializing JSON: \(error)")
                        }
                        
                        
                    } else {
                        callback(nil, "Data is corrupted")
                    }
                    
                } else {
                    callback(nil, "No response from server")
                }
            }
            
        })
        task.resume()
        
    }
    
    /*
     Get friends account more detail info
     recieves Person
     escapes detailed Person
     */
    func getFriendAccount(friend: Person, callback: @escaping (Person?, String?) -> Void) -> Void
    {
        guard let friend_id = friend.info["id"] else {
            return
        }
        
        let url = VKUrls(defaults: defaults).returnURL(task: .usersGet, addition: (String(describing: friend_id!)))
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60000)
        request.httpMethod = "GET"
        
        let task = connection.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            //If there is any error
            if error != nil {
                callback(nil, error?.localizedDescription)
                
            } else {
                
                if (response as? HTTPURLResponse) != nil {
                    
                    //Checking if there any data
                    if data != nil {
                        var friendDictionary = [String: Any?]()
                        do {
                            //creating json from data
                            let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                            //if json contains "response" field - go into it
                            if let response = json!["response"] as? [[String: Any]] {
                                //for each user in response get fields
                                for user in response {
                                    if let id = user["id"] as? Int {
                                        friendDictionary["id"] = id
                                    }
                                    if let firstName = user["first_name"] as? String {
                                        friendDictionary["first_name"] = firstName
                                    }
                                    if let lastName = user["last_name"] as? String {
                                        friendDictionary["last_name"] = lastName
                                    }
                                    if let photo50 = user["photo_50"] as? String {
                                        friendDictionary["photo_50"] = photo50
                                    }
                                    if let photoMaxOrig = user["photo_max_orig"] as? String {
                                        friendDictionary["photo_max_orig"] = photoMaxOrig
                                    }
                                }
                            }
                            //create User obj - friend
                            let friend = Person(info: friendDictionary)
                            callback(friend, nil)
                        } catch {
                            callback(nil,"Error deserializing JSON: \(error)")
                        }
                        
                        
                    } else {
                        callback(nil, "Data is corrupted")
                    }
                    
                } else {
                    callback(nil, "No response from server")
                }
            }
            
        })
        task.resume()
        
    }
    
    /*
     Get avatar 50x50 data to display image
     recieves Person
     escapes Data
     */
    func getAvatar50(forUser user: Person, callback: @escaping (Data?, String?) -> Void) -> Void
    {
        
        guard (user.info["photo_50"] != nil) else {
            return
        }
        
        let urlAvatar = URL(string: (user.info["photo_50"] as? String)!)
        
        let task = connection.dataTask(with: urlAvatar!) { (data, response, error) -> Void in
            
            //If there is any error
            if error != nil {
                callback(nil, error?.localizedDescription)
            } else {
                if (response as? HTTPURLResponse) != nil {
                    
                    //checking if the response contains an image
                    if let imageData = data {
                        
                        callback(imageData,nil)
                        
                    } else {
                        callback(nil,"Image file is currupted")
                    }
                } else {
                    callback(nil, "No response from server")
                }
            }
        }
        task.resume()
        
    }
    
    /*
     Get avatar 100x100 data to display image
     recieves Person
     escapes Data
    */
    func getAvatar100(forUser user: Person, callback: @escaping (Data?, String?) -> Void) -> Void
    {
        
        guard (user.info["photo_100"] != nil) else {
            return
        }
        
        let urlAvatar = URL(string: (user.info["photo_100"] as? String)!)
        
        let task = connection.dataTask(with: urlAvatar!) { (data, response, error) -> Void in
            
            //If there is any error
            if error != nil {
                callback(nil, error?.localizedDescription)
            } else {
                if (response as? HTTPURLResponse) != nil {
                    
                    //checking if the response contains an image
                    if let imageData = data {
                        
                        callback(imageData,nil)
                        
                    } else {
                        callback(nil,"Image file is currupted")
                    }
                } else {
                    callback(nil, "No response from server")
                }
            }
        }
        task.resume()
        
    }
    
    //getting request to load avatar
    func loadPhotoRequest(withUrl url: String) -> URLRequest {
        
        let url = URL(string: url)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60000)
        request.httpMethod = "GET"
        
        return request
    }
    
}

