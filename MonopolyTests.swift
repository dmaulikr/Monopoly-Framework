//
//  MonopolyTests.swift
//  MonopolyTests
//
//  Created by Étienne Beaulé on 15-09-05.
//  Copyright © 2015 Étienne Beaulé. All rights reserved.
//

import XCTest

class MonopolyTests: XCTestCase {
    
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
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

	func testInsufficentFunds() {
		let testPlayer = Player(name: "Test") // Funds set at 1500
		testPlayer.removeFunds(1501) // > than 1500

		XCTAssertEqual(testPlayer.getFunds(), 1500) // Test if did nothing
	}

	func testRemoveFunds() {
		let testPlayer = Player(name: "Test") // Funds set at 1500
		testPlayer.removeFunds(500) // Funds become 1000

		XCTAssertEqual(testPlayer.getFunds(), 1000)
	}

	func testAddFunds() {
		let testPlayer = Player(name: "Test") // Funds set at 1500
		testPlayer.addFunds(500) // Funds become 2000

		XCTAssertEqual(testPlayer.getFunds(), 2000)
	}
}
