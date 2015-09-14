//
// Monopoly framework
//
// Copyright Étienne Beaulé, 2015, All rights reserved
// File created on 31 August 2015
//

import Foundation
/**
Array to hold all spaces on the board
*/
let spaceArray: [Space] = [
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

/// The maximum number of houses per property
let maxHouseNumber = 5

/// The starting price for properties (Brown spaces)
let propertyStartingPrice = 60

/// The difference of price between 2 groups
let propertyAddingPrice = 40

/// The difference of price between the group and the top property of group
let propertyTopPrice = 20

/// The difference between Green and Blue
let topPropertyPrice = 10

/// The difference of price between 2nd last property and last property
let topPropertyTopPrice = 50

/// Price to buy a Railroad
let railroadPrice = 200

/// Price to buy a Utility
let utilityPrice = 150

/// Amount of money a player starts with
let playerStartingFunds = 1500

/// Rent price for railroad if one is owned
let railroadRentPrice = 25

/// Factor for multiplication for a utility if one is owned
/// - SeeAlso: utilityTwoMultiplier
let utilityOneMultiplier = 100

/// Factor for multiplication for a utility if two are owned
/// - SeeAlso: utilityOneMultiplier
let utilityTwoMultiplier = 4

// Cards
/// Array for "Chance" cards
/// - Warning: Only "Get out of Jail Free" cards should get removed (and re-added)
/// - SeeAlso: communityChestCards
var chanceCards: [Card] = []

/// Array for "Community Chest" cards
/// - Warning: Only "Get out of Jail Free" cards should get removed (and re-added)
/// - SeeAlso: chanceCards
var communityChestCards: [Card] = []


/// Makes Space Equatable
///
/// Needed to differentiate between community chest and chance spaces
/// - Warning: Do not use directly
/// - Parameter lhs: Left side of function
/// - Parameter rhs: Right side of function
/// - Returns: Boolean - Whether names are equal
func == (lhs: Space, rhs: Space) -> Bool { // Space
	var isEqual: Bool = false
	if lhs.name == rhs.name && lhs.value == rhs.value { // Name and (arbitrary) value
		isEqual = true
	}
	return isEqual
}

/// Make Player Equatable
///
/// Needed to differentiate between community chest and chance spaces
/// - Warning: Do not use directly
/// - Parameter lhs: Left side of function
/// - Parameter rhs: Right side of function
/// - Returns: Boolean - Whether IDs are equal
func == (lhs: Player, rhs: Player) -> Bool { // Player
	var isEqual = false
	if lhs.id == rhs.id {
		isEqual = true
	}
	return isEqual
}

/// Class to represent a player
class Player: Equatable {
	/// Name of player
	var name: String = ""

	/// Turn number
	var id: Int

	init(name: String, id: Int) {
		self.name = name // Default would be ("Player #")
		self.id = id
	}

	/// Amount of money a player has
	/// - Note: Does not include assets
	private var funds = playerStartingFunds

	/// Whether the player is currently jailed
	/// - SeeAlso: isInJail()
	private var playerInJail: Bool = false // Diff. <-> just visiting and in jail

	/// Whether player has "Get Out Of Jail" card
	/// - Note: Is in Card to allow many cards and to re-add card to array
	var playerHasFreeCard: [Card] = [] // Get out of jail free

	/// Whether player is in jail
	/// - Returns: Boolean
	func isInJail() -> Bool {
		return playerInJail
	}

	/// Current space on which the player is on
	///
	/// When player gets on space, an action is excecuted
	var currentSpace: Space = spaceArray[0] {
		didSet {
			currentSpace.whenPlayerOnSpace(self) // Perform space action
		}
	}

	/// Removes funds from the player
	/// - Note: If not enough funds, does nothing
	/// - SeeAlso: addMoney getFunds
	/// - TODO: Check for enough funds / Bankruptcy
	func removeMoney(amount: Int) {
		if funds < amount {
			/*// Check all possesions
			var combinedWealth
			for space in spaceArray {
			if
			}*/
		} else {
			funds -= amount
		}
	}

	/// Adds funds to the player
	/// - SeeAlso: removeMoney getFunds
	func addMoney(amount: Int) {
		funds += amount
	}

	/// Check funds of player
	/// - SeeAlso: removeMoney addFunds
	func getFunds() -> Int {
		return funds
	}

	/// Send player to jail
	///
	/// Sending a player to jail means that the player
	/// cannot move through the board. A player in jail
	/// has to roll doubles or pay bail to get out.
	///
	/// If player has a card, just move space
	/// - TODO: Remove card from player and re-place in card Array
	func sendToJail() {
		playerInJail = true
		if playerHasFreeCard.isEmpty != true {
			playerInJail = false
			playerHasFreeCard.removeFirst() // Remove free card
		}
		currentSpace = spaceArray[10]
	}

	/// Performed when there is the player's turn
	///
	/// - If doubles are thrown, roll again
	/// - If three doubles are thrown in a row, send to jail
	func onTurn() {
		var dice = diceRoll()

		/// Move space within spaceArray on dice roll
		/// - TODO: Add money if passes "Go"
		func moveSpace() {
			/// Index in spaceArray of Current space
			/// - SeeAlso: spaceArray currentSpace
			let i: Int = spaceArray.indexOf(currentSpace)!
			currentSpace = spaceArray[(dice.die1 + dice.die2 + i) % spaceArray.count]
		}

		/// Count of doubles rolled in a row
		///
		/// If it will equal 3, send to jail,
		/// else move space
		var doublesCount = 0 {
			willSet {
				if doublesCount == 2 {
					sendToJail()
				} else {
					moveSpace()
				}
			}
			didSet {
				moveSpace()
				dice = diceRoll()
			}
		}

		if dice.die1 == dice.die2 {
			doublesCount++
		} else {
			moveSpace()
		}
	}
}

/// Position on Monopoly Board
class Space: Equatable {
	/// Possible actions mandated by space (no subclasses)
	/// - onProperty: Go to subclass
	/// - onTaxes: Remove funds
	/// - onCommunityChest: Draw card
	/// - onChance: Draw card
	/// - toJail: Send player to jail
	enum Action: Int {
		case onProperty = 0
		case onTaxes = 1
		case onCommunityChest = 2
		case onChance = 3
		case toJail = 4
	}

	/// Name of space
	var name: String = ""

	/// Action excecuted if player lands on space
	/// - Note: May be nil (Free Parking)
	var action: Action?

	/// Rent price for taxes
	/// - Note: is nil when not taxes
	var value: Int?

	init(name: String, action: Action?, value: Int? = nil) {
		self.name = name
		self.action = action
		self.value = value
	}

	/// Owner of the space
	/// - Attention: DO NOT USE, use subclass instead
	/// - SeeAlso: OwnedSpace
	var owner: Player?

	/// Price to buy space
	/// - Attention: DO NOT USE, use subclass instead
	/// - SeeAlso: OwnedSpace
	/// - Returns: 0
	var price: Int { return 0 }

	/// Mortgage space
	/// - Attention: DO NOT USE, use subclass instead
	/// - SeeAlso: OwnedSpace
	func mortgageSpace() {}

	/// Take action when on space
	/// - SeeAlso: Action
	/// - Parameter player: Player on space
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

/// Space with an owner
class OwnedSpace: Space {
	/// Type of site
	/// - Railroad
	/// - Utility
	/// - Property: Use Subclass
	enum Site: String {
		case Railroad = "Railroad"
		case Utility = "Utility"
		case Property = "Property"
	}

	/// Owner of the space
	///
	/// If sold while mortgaged, give user option to demortgage
	override var owner: Player? {
		didSet {
			if isMortgaged {
				/// Whether to de-mortgage now or pay 10%
				let mortgageChange = onMortgageChangeChoice()
				if mortgageChange {
					deMorgageSpace()
				} else {
					owner?.removeMoney(mortgagePrice / 10)
				}
			}
		}
	}
	/// Type of Site
	/// - SeeAlso: Site
	var type: Site

	init(name: String, type: Site) {
		self.type = type

		super.init(name: name, action: Action.onProperty, value: nil)
	}

	/// Nominal price to buy space
	/// - SeeAlso: railroadPrice utilityPrice
	override var price: Int {
		/// Used to calculate price
		/// - Returns: Price
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

	/// Price to pay when player lands on space
	var rentPrice: Int {
		/// Used to calculate the price
		var price = 0

		switch type {
		case .Railroad:
			/// Determine if a space is a Railroad and the owner
			/// - Returns: true if space is Railroad and owner is the same
			func isOwnedBySelf(space: Space) -> Bool {
				/// Variable to return
				var isApplic = false
				/// individual space in array as a OwnedSpace
				let owned: OwnedSpace = space as! OwnedSpace
				if (owned.type == .Railroad) && (owned.owner == self.owner) {
					isApplic = true
				}
				return isApplic
			}
			/// Array of railroads owned by same player
			/// - SeeAlso: isOwnedBySelf()
			let filteredArray = spaceArray.filter(isOwnedBySelf)

			switch filteredArray.count {
			case 1:
				price = railroadRentPrice
				fallthrough
			case 2:
				price *= 2
				fallthrough
			case 3:
				price *= 2
				fallthrough
			case 4:
				price *= 2
				fallthrough
			default:
				break
			}
		case .Utility:
			/// Value of dice-roll
			let dice = diceRoll()

			/// Determine if a space is a Utility and the owner
			/// - Returns: true if space is Railroad and owner is the same
			func isOwnedBySelf(space: Space) -> Bool {
				/// Variable to return
				var isApplic = false
				let owned: OwnedSpace = space as! OwnedSpace
				if (owned.type == .Utility) && (owned.owner == self.owner){
					isApplic = true
				}
				return isApplic
			}

			/// Array of utilities owned by same player
			/// - SeeAlso: isOwnedBySelf()
			let filteredArray = spaceArray.filter(isOwnedBySelf)

			price = dice.die1 + dice.die2
			switch filteredArray.count {
			case 1:
				price *= utilityOneMultiplier
				fallthrough
			case 2:
				price *= utilityTwoMultiplier
			default:
				break
			}
		default:
			price = 0
		}
		return price
	}

	/// Price to mortgage a space
	/// - SeeAlso: mortgageSpace()
	var mortgagePrice: Int {
		return self.price / 2
	}

	/// Whether space is mortaged
	/// - SeeAlso: mortgageSpace()
	var isMortgaged: Bool = false

	/// Mortgage the space.
	///
	/// When a space is mortgaged,
	/// the rent price becomes 0 but the
	/// owner gets some funds back.
	/// - SeeAlso: deMortgageSpace()
	override func mortgageSpace() {
		owner?.addMoney(mortgagePrice)
		isMortgaged = true
	}

	/// Demortgage the space
	///
	/// The owner of the space has to pay the mortgage price + 10 %
	/// The rent price becomes the normal rent value
	/// - SeeAlso: mortgageSpace()
	func deMorgageSpace() {
		owner?.removeMoney(mortgagePrice + mortgagePrice / 10) // Price + 10%
		isMortgaged = false
	}

	/// Take action when player lands on space
	///
	/// If the space is mortgaged, do nothing.
	/// If not, give rent to owner
	override func whenPlayerOnSpace(playerOn: Player) {
		if (owner != playerOn) || (isMortgaged == false) {
			playerOn.removeMoney(rentPrice)
			owner?.addMoney(rentPrice)
		}
	}
}

/// Owned space that can have houses
class Property: OwnedSpace {
	/// Group which the property is in (in order)
	/// - Brown
	/// - Light Blue
	/// - Pink
	/// - Orange
	/// - Red
	/// - Yellow
	/// - Green
	/// - Blue
	enum Group: Int {
		case Brown = 0
		case Light_Blue = 1
		case Pink = 2
		case Orange = 3
		case Red = 4
		case Yellow = 5
		case Green = 6
		case Blue = 7

		/// Number of properties in group
		var propNumber: Int {
			switch self {
			case .Brown, .Blue:
				return 2 // Two properties in Brown or Blue
			default:
				return 3 // Three properties elsewhere
			}
		}
	}

	/// Group of which the property is part of
	var group: Group

	/// Position of the property within the group
	var groupPosition: Int

	init(name: String, group: Group, groupPosition: Int) {
		self.group = group
		self.groupPosition = groupPosition

		super.init(name: name, type: .Property)
	}

	/// Number of houses the property has
	/// - TODO: Distribute houses evenly within group
	private var numberOfHouses = 0

	/// Price to buy a house
	/// - TODO: Make logic
	var housePrice: Int {
		return 2
	}

	/// Price to buy property
	/// - SeeAlso: rentPrice
	override var price: Int {
		/// Semi-calculated price by globals
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

	/// Price to pay when player lands on space
	/// - TODO: Make logic
	override var rentPrice: Int { return 0 }

	/// Buy a house on the property
	/// 
	/// Removes full-price of house
	/// - TODO: Distribute houses on group evenly
	/// - SeeAlso: sellHouse()
	func buyHouse() {
		if numberOfHouses < maxHouseNumber {
			numberOfHouses += 1
			owner?.removeMoney(housePrice)
		}
	}

	/// Sell a house on the property
	///
	/// Gives owner half-price of house
	/// - TODO: Remove houses on group evenly
	/// - SeeAlso: buyHouse()
	func sellHouse() {
		if numberOfHouses > 0 {
			numberOfHouses -= 1
			owner?.addMoney(housePrice / 2) // Half price
		}
	}
}

/// A Chance or Community Chest card
class Card {
	/// Choice of Chance or Community Chest cards
	enum format {
		case communityChest
		case chance
	}

	/// Select a card within an array randomly
	/// - SeeAlso: chanceCards communityChestCards
	/// - Parameter type: Card.format either .chance or .communityChest
	static func drawCard(type: format) {
		switch type {
		case .chance:
			break
			// chanceCards
		case .communityChest:
			break
			// communityChestCards
		}
	}
}


/// Provides two random integers between 1 and 6
/// - Returns: Two Integers from 1 to 6
func diceRoll() -> (die1: Int, die2: Int) {
	let die1 = Int(arc4random_uniform(6) + 1)
	let die2 = Int(arc4random_uniform(6) + 1)

	return (die1, die2)
}

// Extra functions

/// Give a choice to a player whether to pay the full
/// de-mortgage price or 10% right away.
func onMortgageChangeChoice() -> Bool {
	return false
}
