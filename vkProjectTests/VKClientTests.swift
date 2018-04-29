//
//  VKClientTests.swift
//  vkProjectTests
//
//  Created by Антон Григорьев on 12.04.2018.
//  Copyright © 2018 Антон Григорьев. All rights reserved.
//

import XCTest
@testable import vkProject

class VKClientTests: XCTestCase {
    
    var vkClient: VKClient!
    var mockUserDefaults: MockUserDefaults!
    
    override func setUp() {
        super.setUp()
        vkClient = VKClient()
        mockUserDefaults = MockUserDefaults(suiteName: "testing")!
        
        vkClient.defaults = mockUserDefaults
    }
    
    override func tearDown() {
        vkClient = nil
        mockUserDefaults = nil
        super.tearDown()
    }
    
    /*
     Test the correct get of user account info
     */
    func testGetUserAccount() {
        //
        //the completion closure performs an asynchronous operation, while the tests run synchronously. This means that the test finishes running while your network request is still processing.
        //so I use expectation
        //
        let expect = expectation(description: "foobar")
        let userExpect = User.init(info: ["id": 210700286,
                                                 "first_name": "Lindsey",
                                                 "last_name": "Stirling",
                                                 "photo_50": "https://sun1-2.userapi.com/c840637/v840637830/2d210/QNPkv6DYZlQ.jpg",
                                                 "photo_100": "https://sun1-4.userapi.com/c840637/v840637830/2d20f/W8Uv-hC7Bvo.jpg",
                                                 "photo_max_orig": "https://sun1-2.userapi.com/c840637/v840637830/2d20d/99JGhFUHcfY.jpg"])
        
        XCTAssertEqual(mockUserDefaults.access_token, "", "access_token should be nothing before start")
        XCTAssertEqual(mockUserDefaults.user_id, "", "user_id should be nothing before start")
        mockUserDefaults.set("b5962bc0f94ed2d32373980aa9399a036838fc254c2a8df854b1959766bb423ffb81278ad3c1cb9c44895", forKey: "access_token")
        mockUserDefaults.set("210700286", forKey: "user_id")
        
        //we need to save current user
        let actualCurrentUser = User.currentUser
        
        vkClient.getUserAccount { (user, error) in
            if (error != nil) {
                XCTFail("Error: \(String(describing: error))")
                return
            }
            XCTAssertEqual(user!, userExpect, "The user expected data should be similar to recieved user data")
            //now return actual current user
            User.currentUser = actualCurrentUser
            expect.fulfill()
        }
        //
        //this will make XCTest wait for up to 10 seconds, giving time for request to fulfill
        //
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
    
    /*
     Test the correct get of friends list
     We will get only first account for test
     */
    func testGetFriendsList() {
        //
        //the completion closure performs an asynchronous operation, while the tests run synchronously. This means that the test finishes running while your network request is still processing.
        //so I use expectation
        //
        let expect = expectation(description: "foobar")
        let userExpect = User.init(info: ["id": 26047,
                                                 "first_name": "Александр",
                                                 "last_name": "Степанов",
                                                 "photo_50": "https://pp.userapi.com/c419029/v419029047/a780/kc4H6CSBRIg.jpg"])
        XCTAssertEqual(mockUserDefaults.access_token, "", "access_token should be nothing before start")
        XCTAssertEqual(mockUserDefaults.user_id, "", "user_id should be nothing before start")
        mockUserDefaults.set("b5962bc0f94ed2d32373980aa9399a036838fc254c2a8df854b1959766bb423ffb81278ad3c1cb9c44895", forKey: "access_token")
        mockUserDefaults.set("210700286", forKey: "user_id")
        
        vkClient.getFriendsList { (friends, error) in
            if (error != nil) {
                XCTFail("Error: \(String(describing: error))")
                return
            }
            XCTAssertEqual(friends![0], userExpect, "The user expected data should be similar to recieved user data")
            expect.fulfill()
            
        }
        //
        //this will make XCTest wait for up to 10 seconds, giving time for request to fulfill
        //
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        
    }
    
    /*
     Test the correct get of friend account info
     */
    func testGetFriendAccount() {
        //
        //the completion closure performs an asynchronous operation, while the tests run synchronously. This means that the test finishes running while your network request is still processing.
        //so I use expectation
        //
        let expect = expectation(description: "foobar")
        let userExpect = User.init(info: ["id": 210700286,
                                                 "first_name": "Lindsey",
                                                 "last_name": "Stirling",
                                                 "photo_50": "https://sun1-2.userapi.com/c840637/v840637830/2d210/QNPkv6DYZlQ.jpg",
                                                 "photo_100": "https://sun1-4.userapi.com/c840637/v840637830/2d20f/W8Uv-hC7Bvo.jpg",
                                                 "photo_max_orig": "https://sun1-2.userapi.com/c840637/v840637830/2d20d/99JGhFUHcfY.jpg"])
        XCTAssertEqual(mockUserDefaults.access_token, "", "access_token should be nothing before start")
        XCTAssertEqual(mockUserDefaults.user_id, "", "user_id should be nothing before start")
        mockUserDefaults.set("b5962bc0f94ed2d32373980aa9399a036838fc254c2a8df854b1959766bb423ffb81278ad3c1cb9c44895", forKey: "access_token")
        mockUserDefaults.set("210700286", forKey: "user_id")
        
        vkClient.getFriendAccount(friend: Person.init(info: ["id": 210700286])) { (friend, error) in
            if (error != nil) {
                XCTFail("Error: \(String(describing: error))")
                return
            }
            XCTAssertEqual(friend!, userExpect, "The user expected data should be similar to got recieved data")
            expect.fulfill()
        }
        //
        //this will make XCTest wait for up to 10 seconds, giving time for request to fulfill
        //
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        
    }
    
    /*
     Test the correct get of avatar 50x50 data
     */
    func testGetAvatar50() {
        //
        //the completion closure performs an asynchronous operation, while the tests run synchronously. This means that the test finishes running while your network request is still processing.
        //so I use expectation
        //
        let expect = expectation(description: "foobar")
        let userExpect = User.init(info: ["id": 210700286,
                                                 "first_name": "Lindsey",
                                                 "last_name": "Stirling",
                                                 "photo_50": "https://sun1-2.userapi.com/c840637/v840637830/2d210/QNPkv6DYZlQ.jpg",
                                                 "photo_100": "https://sun1-4.userapi.com/c840637/v840637830/2d20f/W8Uv-hC7Bvo.jpg",
                                                 "photo_max_orig": "https://sun1-2.userapi.com/c840637/v840637830/2d20d/99JGhFUHcfY.jpg"])
        let imageDataExpect = try! Data(contentsOf: URL(string: userExpect.info["photo_50"] as! String)!)
        
        XCTAssertEqual(mockUserDefaults.access_token, "", "access_token should be nothing before start")
        XCTAssertEqual(mockUserDefaults.user_id, "", "user_id should be nothing before start")
        mockUserDefaults.set("b5962bc0f94ed2d32373980aa9399a036838fc254c2a8df854b1959766bb423ffb81278ad3c1cb9c44895", forKey: "access_token")
        mockUserDefaults.set("210700286", forKey: "user_id")
        
        vkClient.getAvatar50(forUser: userExpect, callback: { (imageData, error) in
            if (error != nil) {
                XCTFail("Error: \(String(describing: error))")
                return
            }
            XCTAssertEqual(imageData!, imageDataExpect, "The image expected data should be similar to recieved users data")
            expect.fulfill()
        })
        
        //
        //this will make XCTest wait for up to 20 seconds, giving time for request to fulfill
        //
        waitForExpectations(timeout: 20) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        
    }
    
    /*
     Test the correct get of avatar 100x100 data
     */
    func testGetAvatar100() {
        //
        //the completion closure performs an asynchronous operation, while the tests run synchronously. This means that the test finishes running while your network request is still processing.
        //so I use expectation
        //
        let expect = expectation(description: "foobar")
        let userExpect = User.init(info: ["id": 210700286,
                                                 "first_name": "Lindsey",
                                                 "last_name": "Stirling",
                                                 "photo_50": "https://sun1-2.userapi.com/c840637/v840637830/2d210/QNPkv6DYZlQ.jpg",
                                                 "photo_100": "https://sun1-4.userapi.com/c840637/v840637830/2d20f/W8Uv-hC7Bvo.jpg",
                                                 "photo_max_orig": "https://sun1-2.userapi.com/c840637/v840637830/2d20d/99JGhFUHcfY.jpg"])
        let imageDataExpect = try! Data(contentsOf: URL(string: userExpect.info["photo_100"] as! String)!)
        
        XCTAssertEqual(mockUserDefaults.access_token, "", "access_token should be nothing before start")
        XCTAssertEqual(mockUserDefaults.user_id, "", "user_id should be nothing before start")
        mockUserDefaults.set("b5962bc0f94ed2d32373980aa9399a036838fc254c2a8df854b1959766bb423ffb81278ad3c1cb9c44895", forKey: "access_token")
        mockUserDefaults.set("210700286", forKey: "user_id")
        
        vkClient.getAvatar100(forUser: userExpect, callback: { (imageData, error) in
            if (error != nil) {
                XCTFail("Error: \(String(describing: error))")
                return
            }
            XCTAssertEqual(imageData!, imageDataExpect, "The image expected data should be similar to recieved user data")
            expect.fulfill()
        })
        
        //
        //this will make XCTest wait for up to 20 seconds, giving time for request to fulfill
        //
        waitForExpectations(timeout: 20) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        
    }  
    
}

