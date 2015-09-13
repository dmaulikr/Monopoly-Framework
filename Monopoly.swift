//
// Monopoly framework
//
// Copyright Étienne Beaulé, 2015, All rights reserved
// File created on 31 August 2015
//

import Foundation
/**
Holds all spaces on the board
*/
var spaceArray: [Space] = [
	Space(name: "Go", action: nil), // Collection after going through array, not onSpace
	Property(name: "Mediterranean Avenue", group: .Brown, groupPosition: 1),
	Space(name: "Community Chest", action: .onCommunityChest),
	Property(name: "Baltic Avenue", group: .Brown, groupPosition: 2),
	Space(name: "Income Tax", action: .onTaxes, value: 200),
	OwnedSpace(name: "Reading Railroad", type: .Railroad),
	Property(name: "Oriental Avenue", group: .Light_Blue, groupPosition: 1),
	Space(name: "Chance", action: .onChance),
	Property(name: "Vermont Avenue", group: .Light_Blue, groupPosition: 2),
	Property(name: "Connecticut Avenue", group: .Light_Blue, groupPosition: 3),
	Space(name: "In Jail / Just Visiting", action: nil),
	Property(name: "St. Charles Place", group: .Pink, groupPosition: 1),
	OwnedSpace(name: "Electric Company", type: .Utility),
	Property(name: "States Avenue", group: .Pink, groupPosition: 2),
	Property(name: "Virginia Avenue", group: .Pink, groupPosition: 3),
	OwnedSpace(name: "Pennsylvania Railroad", type: .Railroad),
	Property(name: "St. James Place", group: .Orange, groupPosition: 1),
	Space(name: "Community Chest", action: .onCommunityChest, value: 1),
	Property(name: "Tennessee Avenue", group: .Orange, groupPosition: 2),
	Property(name: "New York Avenue", group: .Orange, groupPosition: 3),
	Space(name: "Free Parking", action: nil),
	Property(name: "Kentucky Avenue", group: .Red, groupPosition: 1),
	Space(name: "Chance", action: .onChance, value: 1),
	Property(name: "Indiana Avenue", group: .Red, groupPosition: 2),
	Property(name: "Illinois Avenue", group: .Red, groupPosition: 3),
	OwnedSpace(name: "B&O Railroad", type: .Railroad),
	Property(name: "Atlantic Avenue", group: .Yellow, groupPosition: 1),
	Property(name: "Ventnor Avenue", group: .Yellow, groupPosition: 2),
	OwnedSpace(name: "Water Works", type: .Utility),
	Property(name: "Marvin Gardens", group: .Yellow, groupPosition: 3),
	Space(name: "Go to Jail", action: .toJail),
	Property(name: "Pacific Avenue", group: .Green, groupPosition: 1),
	Property(name: "North Carolina Avenue", group: .Green, groupPosition: 2),
	Space(name: "Community Chest", action: .onCommunityChest, value: 2),
	Property(name: "Pennsylvania Avenue", group: .Green, groupPosition: 3),
	OwnedSpace(name: "Short Line", type: .Railroad),
	Space(name: "Chance", action: .onChance, value: 2),
	Property(name: "Park Place", group: .Blue, groupPosition: 1),
	Space(name: "Luxury Tax", action: .onTaxes, value: 100),
	Property(name: "Boardwalk", group: .Blue, groupPosition: 2)
]

// Set up settings
let maxHouseNumber = 5
let propertyStartingPrice = 60
let propertyAddingPrice = 40
let propertyTopPrice = 20
let topPropertyPrice = 10
let topPropertyTopPrice = 50
let railroadPrice = 200
let utilityPrice = 150
let playerStartingFunds = 1500

// Cards
let chanceCards: [Card] = []
let communityChestCards: [Card] = []


/* Make Space & Player Equatable
* Needed to differentiate between community chest and chance spaces
*/
func == (lhs: Space, rhs: Space) -> Bool { // Space
	var isEqual: Bool = false
	if lhs.name == rhs.name && lhs.value == rhs.value { // Name and (arbitrary) value
		isEqual = true
	}
	return isEqual
}

func == (lhs: Player, rhs: Player) -> Bool { // Player
	var isEqual = false
	if lhs.id == rhs.id {
		isEqual = true
	}
	return isEqual
}

class Player: Equatable {
	var name: String = "" // Name of player
	var id: Int // Turn #

	init(name: String, id: Int) {
		self.name = name // Default would be ("Player #")
		self.id = id
	}

	private var funds: Int = playerStartingFunds // Current amount of money * Default = 1500

	private var playerInJail: Bool = false // Diff. <-> just visiting and in jail
	var playerHasFreeCard: [Card.format] = [] // Get out of jail free
	func isInJail() -> Bool {
		return playerInJail
	}

	var currentSpace: Space = spaceArray[0] {
		didSet {
			currentSpace.whenPlayerOnSpace(self) // Perform space action
		}
	}

	func removeMoney(amount: Int) {
		if funds < amount {
			/*// Check all possesions
			var combinedWealth
			for space in spaceArray {
			if
			}*/
			/// TODO: Check all possesions, if < amount, bankrupt and switch owner
			/// TODO: Give player option
		} else {
			funds -= amount
		}
	}

	func addMoney(amount: Int) {
		funds += amount
	}

	func getFunds() -> Int {
		return funds
	}

	func sendToJail() {
		playerInJail = true
		if playerHasFreeCard.isEmpty != true {
			playerInJail = false
			playerHasFreeCard.removeFirst() // Remove free card, no diff between type
		}
		currentSpace = spaceArray[10]
	}

	// On turn if doubles thrown three times, send to jail
	func onTurn() {
		var dice = diceRoll()

		func moveSpace() {
			let i: Int? = spaceArray.indexOf(currentSpace)
			currentSpace = spaceArray[(dice.die1 + dice.die2 + i!) % spaceArray.count]
		}

		var doublesCount: Int = 0 {
			willSet {
				if doublesCount == 2 {
					sendToJail()
				} else {
					moveSpace()
				}
			}
			didSet {
				moveSpace()
				dice = diceRoll() // If doubles, roll again
			}
		}

		if dice.die1 == dice.die2 {
			doublesCount++
		} else {
			moveSpace()
		}
	}
}

class Space: Equatable {
	enum Action: Int {
		case onProperty = 0
		case onTaxes = 1
		case onCommunityChest = 2
		case onChance = 3
		case toJail = 4
	}

	var name: String = ""
	var action: Action?
	var value: Int?

	init(name: String, action: Action?, value: Int? = nil) {
		self.name = name
		self.action = action
		self.value = value
	}

	var owner: Player?
	var price: Int {return 0}
	func mortgageSpace() {}

	func whenPlayerOnSpace(player: Player) {
		if action != nil {
			switch action! {
			case .onProperty:
				break
			case .onTaxes:
				player.removeMoney(value!)
			case .onCommunityChest:
				Card.drawCard(.communityChest)
			case .onChance:
				Card.drawCard(.chance)
			case .toJail:
				player.sendToJail()
			}
		}
	}
}

class OwnedSpace: Space {
	enum Site: String {
		case Railroad = "Railroad"
		case Utility = "Utility"
		case Property = "Property"
	}

	override var owner: Player? {
		didSet {
			if isMortgaged {
				let mortgageChange = onMortgageChangeChoice() // User option
				if mortgageChange {
					deMorgageSpace()
				} else {
					owner?.removeMoney(mortgagePrice / 10) // Remove 10%
				}
			}
		}
	}
	var type: Site

	init(name: String, type: Site) {
		self.type = type

		super.init(name: name, action: Action.onProperty, value: nil)
	}

	override var price: Int {
		var price = 0

		switch type {
		case .Railroad:
			price = railroadPrice
		case .Utility:
			price = utilityPrice
		case .Property:
			break
		}
		return price
	}
	var rentPrice: Int {
		var price = 0
		switch type {
		case .Railroad:
			func isOwnedBySelf(space: Space) -> Bool {
				var isApplic = false
				let owned: OwnedSpace = space as! OwnedSpace
				if (owned.type == .Railroad) && (owned.owner == self.owner){
					isApplic = true
				}
				return isApplic
			}
			let filteredArray = spaceArray.filter(isOwnedBySelf)

			switch filteredArray.count {
			case 1:
				price = 50
			case 2:
				price = 100
			case 3:
				price = 200
			default:
				price = 25
			}
		case .Utility:
			let dice = diceRoll()

			func isOwnedBySelf(space: Space) -> Bool {
				var isApplic = false
				let owned: OwnedSpace = space as! OwnedSpace
				if (owned.type == .Utility) && (owned.owner == self.owner){
					isApplic = true
				}
				return isApplic
			}
			let filteredArray = spaceArray.filter(isOwnedBySelf)

			price = dice.die1 + dice.die2
			if filteredArray.count == 1 {
				price *= 100
			} else {
				price *= 40
			}
		default:
			price = 0
		}
		return price
	}
	var mortgagePrice: Int {
		return self.price / 2
	}

	var isMortgaged: Bool = false
	override func mortgageSpace() {
		owner?.addMoney(mortgagePrice)
		isMortgaged = true
	}

	func deMorgageSpace() {
		owner?.removeMoney(mortgagePrice + mortgagePrice / 10) // Price + 10%
		isMortgaged = false
	}

	override func whenPlayerOnSpace(playerOn: Player) {
		if (owner != playerOn) || (isMortgaged == false) {
			playerOn.removeMoney(rentPrice)
			owner?.addMoney(rentPrice)
		}
	}
}

class Property: OwnedSpace {
	enum Group: Int {
		case Brown = 0
		case Light_Blue = 1
		case Pink = 2
		case Orange = 3
		case Red = 4
		case Yellow = 5
		case Green = 6
		case Blue = 7

		var propNumber: Int {
			switch self {
			case .Brown, .Blue:
				return 2 // Two properties in Brown or Blue
			default:
				return 3 // Three properties elsewhere
			}
		}
	}

	var group: Group
	var groupPosition: Int

	init(name: String, group: Group, groupPosition: Int) {
		self.group = group
		self.groupPosition = groupPosition

		super.init(name: name, type: .Property)
	}

	private var numberOfHouses = 0
	var housePrice: Int {
		return 2
	}

	override var price: Int {
		var price = group.rawValue * propertyAddingPrice + propertyStartingPrice

		switch group {
		case .Blue:
			price += topPropertyPrice

			if groupPosition == 2 {
				price += topPropertyTopPrice
			}
		default:
			if groupPosition == 3 {
				price += propertyTopPrice
			}
		}
		return price
	}
	/*
	override var rentPrice: Int {
		return 0
	}
	*/
	func buyHouse() {
		if numberOfHouses < maxHouseNumber {
			numberOfHouses += 1
			owner?.removeMoney(housePrice)
		}
	}

	func sellHouse() {
		if numberOfHouses > 0 {
			numberOfHouses -= 1
			owner?.addMoney(housePrice / 2) // Half price
		}
	}
}
class Card {
	enum format {
		case communityChest
		case chance
	}

	static func drawCard(type: format) {
		switch type {
		case .chance:
			chanceCards
		case .communityChest:
			communityChestCards
		}
	}
}


// Provides one integer between 1 and 6 for each die (2)
func diceRoll() -> (die1: Int, die2: Int) {
	let die1 = Int(arc4random_uniform(6) + 1)
	let die2 = Int(arc4random_uniform(6) + 1)

	return (die1, die2)
}

// Extra functions

func onMortgageChangeChoice() -> Bool {
	return false
}
