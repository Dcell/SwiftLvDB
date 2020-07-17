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
    var sldb:SwiftLvDB!

    override func setUpWithError() throws {
        sldb = SwiftLvDB(subName: "sldb", 0)//ignore memory cache
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
        sldb.set(testValue, forKey: testKey)
        XCTAssertFalse(testValue != sldb.integer(forKey: testKey))
    }
    func testSaveFloat() throws{
        let testValue:Float = 1.0
        let testKey = "testSaveFloat"
        sldb.set(testValue, forKey: testKey)
        XCTAssertFalse(testValue != sldb.float(forKey: testKey))
    }
    
    func testSaveDouble() throws{
        let testValue:Double = 1.0
        let testKey = "testSaveDouble"
        sldb.set(testValue, forKey: testKey)
        XCTAssertFalse(testValue != sldb.double(forKey: testKey))
    }
    
    func testSaveBool() throws{
        let testValue:Bool = true
        let testKey = "testSaveBool"
        sldb.set(testValue, forKey: testKey)
        XCTAssertFalse(testValue != sldb.bool(forKey: testKey))
    }
    
    func testSaveString() throws{
        let testValue:String = "hello"
        let testKey = "testSaveString"
        sldb.set(testValue, forKey: testKey)
        XCTAssertFalse(testValue != sldb.string(forKey: testKey))
    }
    
    func testSaveCodeable() throws{
        struct TestStruct:Codable,Equatable{
            var a:Int
            var b:String
            
            static func == (lhs: Self, rhs: Self) -> Bool{
                return lhs.a == rhs.a && lhs.b == rhs.b
            }
        }
        let testKey = "testSaveCodeable"
        let testvalue = TestStruct(a: 1, b: "hello")
        try sldb.set(testvalue, forKey: testKey)
        XCTAssertFalse(testvalue != sldb.codeableObject(TestStruct.self, forKey: testKey))
    }
    
    func testSaveList() throws{
        let testValue:[Int] = [1,2,3,4,5]
        let testKey = "testSaveList"
        try sldb.set(testValue, forKey: testKey)
        XCTAssertFalse(testValue != sldb.codeableObject([Int].self, forKey: testKey))
    }
    
    func testSaveHashMap() throws{
        var testValue:[String:Int] = [:]
        testValue["1"] = 1
        testValue["2"] = 2
        
        let testKey = "testSaveList"
        try sldb.set(testValue, forKey: testKey)
        XCTAssertFalse(testValue != sldb.codeableObject([String:Int].self, forKey: testKey))
    }
    
    func testSaveInt100000Times() throws{
        for index in 0...100000 {
            let testValue = index
            let testKey = "testSaveInt\(index)"
            sldb.set(testValue, forKey: testKey)
            XCTAssertFalse(testValue != sldb.integer(forKey: testKey))
        }
    }
    
    func testSaveString100000Times() throws{
        for index in 0...100000 {
            let testValue = "testString\(index)"
            let testKey = "testSaveString\(index)"
            sldb.set(testValue, forKey: testKey)
            XCTAssertFalse(testValue != sldb.string(forKey: testKey))
        }
    }
    
    func testSaveCodeable100000Times() throws{
        struct TestStruct:Codable,Equatable{
            var a:Int
            var b:String
            
            static func == (lhs: Self, rhs: Self) -> Bool{
                return lhs.a == rhs.a && lhs.b == rhs.b
            }
        }
        for index in 0...100000 {
            let testValue = TestStruct(a: index, b: "index\(index)")
            let testKey = "testSaveCodeable\(index)"
                
            try sldb.set(testValue, forKey: testKey)
            XCTAssertFalse(testValue != sldb.codeableObject(TestStruct.self, forKey: testKey))
        }
    }

}
