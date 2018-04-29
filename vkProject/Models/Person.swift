//
//  Person.swift
//  vkProject
//
//  Created by Антон Григорьев on 11.04.2018.
//  Copyright © 2018 Антон Григорьев. All rights reserved.
//

import Foundation

class Person {
    
    /*
     Dictionary for user:
     id - user id
     first_name - user first name
     last_name - user last name
     photo_50 - url for avatar in 50x50
     avatar50_imageData - avatar 50x50 data to present image
     photo_max_orig - avatar for preview
     photo_100 - url for avatar in 50x50
     avatar100_imageData - avatar 100x100 data to present image
     */
    var info: [String: Any?] = ["id": nil,
                                      "first_name": nil,
                                      "last_name": nil,
                                      "photo_50" : nil,
                                      "avatar50_imageData": nil,
                                      "photo_max_orig": nil,
                                      "photo_100": nil,
                                      "avatar100_imageData": nil]
    
    //Use dictionary to make its components optional for initializing
    init(info: [String: Any?]) {
        self.info = info
    }
    
    public func fullname() -> String {
        
        return (self.info["first_name"] as? String)! + " " + (self.info["last_name"] as? String)!
    }
    
}

/*
 Extension to make class equatable by "id" field in dictionary
 */
extension Person: Equatable {
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return (lhs.info["id"] as! Int) == (rhs.info["id"] as! Int)
        
    }
    
}
