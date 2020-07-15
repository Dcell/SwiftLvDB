//
//  swift_lvdb_demoTests.swift
//  swift-lvdb-demoTests
//
//  Created by mac_25648_newMini on 2020/7/15.
//  Copyright © 2020 mac_25648_newMini. All rights reserved.
//

import XCTest
import SwiftLvDB

class swift_lvdb_demoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSaveInt() throws{
        let testValue = 1
        let testKey = "testSaveInt"
        SwiftLvDB.sharedInstance.set(testValue, forKey: testKey)
        XCTAssertFalse(testValue != SwiftLvDB.sharedInstance.integer(forKey: testKey))
    }
    func testSaveFloat() throws{
        let testValue:Float = 1.0
        let testKey = "testSaveFloat"
        SwiftLvDB.sharedInstance.set(testValue, forKey: testKey)
        XCTAssertFalse(testValue != SwiftLvDB.sharedInstance.float(forKey: testKey))
    }
    
    func testSaveDouble() throws{
        let testValue:Double = 1.0
        let testKey = "testSaveDouble"
        SwiftLvDB.sharedInstance.set(testValue, forKey: testKey)
        XCTAssertFalse(testValue != SwiftLvDB.sharedInstance.double(forKey: testKey))
    }
    
    func testSaveBool() throws{
        let testValue:Bool = true
        let testKey = "testSaveBool"
        SwiftLvDB.sharedInstance.set(testValue, forKey: testKey)
        XCTAssertFalse(testValue != SwiftLvDB.sharedInstance.bool(forKey: testKey))
    }
    
    func testSaveString() throws{
        let testValue:String = "hello"
        let testKey = "testSaveBool"
        SwiftLvDB.sharedInstance.set(testValue, forKey: testKey)
        XCTAssertFalse(testValue != SwiftLvDB.sharedInstance.string(forKey: testKey))
    }

}
