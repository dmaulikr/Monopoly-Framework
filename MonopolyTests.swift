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
		let testPlayer = Player(name: "Test", id: 0) // Funds set at 1500
		testPlayer.removeMoney(1501) // > than 1500

		XCTAssertEqual(testPlayer.getFunds(), 1500) // Test if did nothing
	}

	func testRemoveFunds() {
		let testPlayer = Player(name: "Test", id: 0) // Funds set at 1500
		testPlayer.removeMoney(500) // Funds become 1000

		XCTAssertEqual(testPlayer.getFunds(), 1000)
	}

	func testAddFunds() {
		let testPlayer = Player(name: "Test", id: 0) // Funds set at 1500
		testPlayer.addMoney(500) // Funds become 2000

		XCTAssertEqual(testPlayer.getFunds(), 2000)
	}

	func testSendToJail() {
		let testPlayer = Player(name: "Test", id: 0)
		testPlayer.currentSpace = spaceArray[0]
		testPlayer.sendToJail()

		XCTAssert(testPlayer.isInJail())
	}

	func testSendToJailWithCard() {
		let testPlayer = Player(name: "Test", id: 0)
		testPlayer.playerHasFreeCard.append(Card())
		testPlayer.sendToJail()

		XCTAssert(testPlayer.playerHasFreeCard.isEmpty)
		XCTAssertEqual(testPlayer.currentSpace, spaceArray[10])
	}

	func testOnTaxes() {
		let testPlayer = Player(name: "Test", id: 0)
		testPlayer.currentSpace = spaceArray[4]

		XCTAssertEqual(testPlayer.getFunds(), 1300)
	}

	func testOnUnownedProperty() {
		let testSpace = Property(name: "Mediterranean Avenue", group: .Brown, groupPosition: 1)
		let testPlayer = Player(name: "Test", id: 0)
		testPlayer.currentSpace = testSpace

		XCTAssertEqual(testPlayer.getFunds(), 1500)
	}
/* Functionality non-existant
	func testOnOwnedProperty() {
		let testSpace = Property(name: "Mediterranean Avenue", group: .Brown, groupPosition: 1)
		let testPlayer = Player(name: "Test", id: 0)
		let testLandlord = Player(name: "Landlord", id: 1)

		testSpace.owner = testLandlord
		testPlayer.currentSpace = testSpace

		XCTAssertEqual(testLandlord.getFunds(), 1540)
	}

	func testOnOwnedGroup() {
		let testPlayer = Player(name: "Test", id: 0)
		let testLandlord = Player(name: "Landlord", id: 1)
	}

	func testOnUtility1Owned() {
		let	testSpace = OwnedSpace(name: "Electric Company", type: .Utility)
		let testPlayer = Player(name: "Test", id: 0)
		let testLandlord = Player(name: "Landlord", id: 1)

		testSpace.owner = testLandlord
		testPlayer.currentSpace = testSpace

		XCTAssert(testPlayer.getFunds() <= 1420) // 1500 - 2 * 40
		XCTAssert(testLandlord.getFunds() >= 1580) // 1500 + 2 * 40
	}

	func testOnUtility2Onwed() {
		let	testSpace1 = OwnedSpace(name: "Electric Company", type: .Utility)
		let testSpace2 = OwnedSpace(name: "Water Works", type: .Utility)
		let testPlayer = Player(name: "Test", id: 0)
		let testLandlord = Player(name: "Landlord", id: 1)

		testSpace1.owner = testLandlord
		testSpace2.owner = testLandlord
		testPlayer.currentSpace = testSpace2

		XCTAssert(testLandlord.getFunds() >= 1700) // 1500 + 2 * 100
		XCTAssert(testPlayer.getFunds() <= 1300) // 1500 - 2 * 100
	}

	func testOnRail1Owned() {
		let testSpace = OwnedSpace(name: "Reading Railroad", type: .Railroad)
		let testPlayer = Player(name: "Test", id: 0)
		let testLandlord = Player(name: "Landlord", id: 1)

		testSpace.owner = testLandlord
		testPlayer.currentSpace = testSpace

		XCTAssertEqual(testPlayer.getFunds(), 1475) // 1500 - 25
		XCTAssertEqual(testLandlord.getFunds(), 1525) // 1500 + 25
	}

	func testOnRail3Owned() {
		let testSpace1 = OwnedSpace(name: "Reading Railroad", type: .Railroad)
		let testSpace2 = OwnedSpace(name: "Reading1 Railroad", type: .Railroad)
		let testSpace3 = OwnedSpace(name: "Reading2 Railroad", type: .Railroad)
		let testPlayer = Player(name: "Test", id: 0)
		let testLandlord = Player(name: "Landlord", id: 1)

		testSpace1.owner = testLandlord
		testSpace2.owner = testLandlord
		testSpace3.owner = testLandlord
		testPlayer.currentSpace = testSpace1

		XCTAssertEqual(testPlayer.getFunds(), 1400)
		XCTAssertEqual(testLandlord.getFunds(), 1600)
	}
*/
	func testMortgageSpaceMoneyReturned() {
		let testLandlord = Player(name: "Landlord", id: 1)

		spaceArray[1].owner = testLandlord // Mediterranean Avenue
		spaceArray[1].mortgageSpace()

		XCTAssertEqual(testLandlord.getFunds(), 1530) // 1500 + 60 / 2
	}

	func testMortgageSpaceNoRent() {
		let testPlayer = Player(name: "Test", id: 0)
		let testLandlord = Player(name: "Landlord", id: 1)

		spaceArray[1].owner = testLandlord // Mediterranean Avenue
		spaceArray[1].mortgageSpace()
		testLandlord.removeMoney(30) // Remove mortgage
		testPlayer.currentSpace = spaceArray[1]

		XCTAssertEqual(testPlayer.getFunds(), 1500) // No change
		XCTAssertEqual(testLandlord.getFunds(), 1500) // No change
	}
/* Functionality non-existant (no option)
	func testDemortgageSpace10() {

	}

	func testMortgageSpaceSold() {

	}
*/
	func testCorrectPropertyPriceStarting() {
		XCTAssertEqual(spaceArray[1].price, 60) // Mediterranean Avenue
	}

	func testStartPropertyTopOverride() {
		XCTAssertEqual(spaceArray[3].price, 60) // Baltic Avenue
	}

	func testPropertyPriceCalculation() {
		XCTAssertEqual(spaceArray[26].price, 260) // Atlantic Avenue
	}

	func testTopPropertyPriceCalculation() {
		XCTAssertEqual(spaceArray[29].price, 280) // Marvin Gardens
	}
/* Functionality non-existant
	func testBuyProperty() {

	}

	func testBuyHouseNotFullGroup() {
		
	}

	func testBuyHouseFullGroup() {

	}

	func testBuyHouseOverMax() {

	}

	func testRentPriceWHotel() {

	}

	func testDistributeHouse() {

	}

	func testSellHouse() {

	}
*/
}
