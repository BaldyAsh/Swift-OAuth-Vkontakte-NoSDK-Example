//
//  VKUrlsTests.swift
//  vkProjectTests
//
//  Created by Антон Григорьев on 13.04.2018.
//  Copyright © 2018 Антон Григорьев. All rights reserved.
//

import XCTest
@testable import vkProject

class VKUrlsTests: XCTestCase {
    
    var vkUrls: VKUrls!
    var mockUserDefaults: MockUserDefaults!
    
    override func setUp() {
        super.setUp()
        
        mockUserDefaults = MockUserDefaults(suiteName: "testing")!
        vkUrls = VKUrls(defaults: mockUserDefaults)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /*
     Test the correct get login url
     */
    func testGetCorrectLoginUrl() {
        
        XCTAssertEqual(mockUserDefaults.access_token, "", "access_token should be nothing before start")
        XCTAssertEqual(mockUserDefaults.user_id, "", "user_id should be nothing before start")
        mockUserDefaults.set("b5962bc0f94ed2d32373980aa9399a036838fc254c2a8df854b1959766bb423ffb81278ad3c1cb9c44895", forKey: "access_token")
        mockUserDefaults.set("210700286", forKey: "user_id")
        
        let urlLoginExpect = URL(string: "https://oauth.vk.com/authorize?client_id=6443086&display=page&redirect_uri=https://oauth.vk.com/blank.html&scope=friends,photos,offline&response_type=token&v=5.52")!
        
        let urlLogin = vkUrls.returnURL(task: .login, addition: nil)
        
        XCTAssertEqual(urlLoginExpect, urlLogin, "The expected login url should be similar to recieved login url")
    }
    
    /*
     Test the correct get Users Get url
     */
    func testGetCorrectUsersGetUrl() {
        
        XCTAssertEqual(mockUserDefaults.access_token, "", "access_token should be nothing before start")
        XCTAssertEqual(mockUserDefaults.user_id, "", "user_id should be nothing before start")
        mockUserDefaults.set("b5962bc0f94ed2d32373980aa9399a036838fc254c2a8df854b1959766bb423ffb81278ad3c1cb9c44895", forKey: "access_token")
        mockUserDefaults.set("210700286", forKey: "user_id")
        
        let urlUsersGetExpect = URL(string: "https://api.vk.com/method/users.get?user_id=210700286&fields=photo_50,photo_max_orig,photo_100&access_token=b5962bc0f94ed2d32373980aa9399a036838fc254c2a8df854b1959766bb423ffb81278ad3c1cb9c44895&v=5.52")!
        
        let urlUsersGet = vkUrls.returnURL(task: .usersGet, addition: nil)
        
        XCTAssertEqual(urlUsersGetExpect, urlUsersGet, "The expected users get url should be similar to recieved users get url")
        
    }
    
    /*
     Test the correct get Friends Get url
     */
    func testGetCorrectFriendsGetUrl() {
        
        XCTAssertEqual(mockUserDefaults.access_token, "", "access_token should be nothing before start")
        XCTAssertEqual(mockUserDefaults.user_id, "", "user_id should be nothing before start")
        mockUserDefaults.set("b5962bc0f94ed2d32373980aa9399a036838fc254c2a8df854b1959766bb423ffb81278ad3c1cb9c44895", forKey: "access_token")
        mockUserDefaults.set("210700286", forKey: "user_id")
        
        let urlFriendsGetExpect = URL(string: "https://api.vk.com/method/friends.get?user_id=210700286&order=name&fields=photo_50&access_token=b5962bc0f94ed2d32373980aa9399a036838fc254c2a8df854b1959766bb423ffb81278ad3c1cb9c44895&v=5.52")!
        
        let urlFriendsGet = vkUrls.returnURL(task: .friendsGet, addition: nil)
        
        XCTAssertEqual(urlFriendsGetExpect, urlFriendsGet, "The expected friends get url should be similar to recieved friends get url")
        
    }
    
}
