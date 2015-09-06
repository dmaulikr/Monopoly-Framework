//
// Monopoly framework
//
// Copyright Étienne Beaulé, 2015, All rights reserved
// File created on 31 August 2015
//

import Foundation

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

	private var money: Int = startingMoney // Current amount of money

	private var playerInJail: Bool = false // Diff. <-> just visiting and in jail
	var playerHasFreeCard: [Card.format] = [] // Get out of jail free
	func isInJail() -> Bool {
		return playerInJail
	}

	var currentSpace: Space = start {
		didSet {
			currentSpace.whenPlayerOnSpace(self) // Perform space action
		}
	}

	func removeMoney(amount: Int) {
		if money < amount {
			/*// Check all possesions
			var combinedWealth
			for space in spaceArray {
			if
			}*/
			/// TODO: Check all possesions, if < amount, bankrupt and switch owner
			/// TODO: Give player option
		} else {
			money -= amount
		}
	}

	func addMoney(amount: Int) {
		money += amount
	}

	func getFunds() -> Int {
		return money
	}

	func sendToJail() {
		playerInJail = true
		if playerHasFreeCard.isEmpty != true {
			playerInJail = false
			playerHasFreeCard.removeFirst() // Remove free card, no diff between type
		}
		currentSpace = jailVisit
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

	var owner: Player? = nil {
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

	var price: Int {
		var price = 0

		switch type {
		case .Railroad:
			price = railPrice
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
				price *= 10
			} else {
				price += 4
			}
		default:
			price = 0
		}
		return price
	}
	var mortgagePrice: Int {
		return price / 2
	}

	var isMortgaged: Bool = false
	func mortgageSpace() {
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

	private var numberOfHouses: UInt = 0
	var housePrice: Int {
		return 2
	}

	override var price: Int {
		var price = group.rawValue * propAddingPrice + propStartingPrice

		switch group {
		case .Blue:
			price += 10

			if groupPosition == 2 {
				price += 50
			}
		default:
			if groupPosition == 3 {
				price += propTopGroupPrice
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