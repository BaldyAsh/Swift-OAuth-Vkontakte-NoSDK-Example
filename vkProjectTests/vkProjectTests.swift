//
//  vkProjectTests.swift
//  vkProjectTests
//
//  Created by Антон Григорьев on 12.04.2018.
//  Copyright © 2018 Антон Григорьев. All rights reserved.
//

import XCTest

class vkProjectTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

/*
 MockUserDefaults overrides the set for key method to correctly update UserDefaults for tests
 */
public class MockUserDefaults: UserDefaults {
    var access_token = ""
    var user_id = ""
    override public func set(_ value: Int, forKey defaultName: String) {
        switch defaultName {
        case "access_token":
            access_token = defaultName
            break
        case "user_id":
            user_id = defaultName
            break
        default:
            break
        }
    }
}
