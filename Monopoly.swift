//
// Monopoly framework
//
// Copyright Étienne Beaulé, 2015, All rights reserved
// File created on 31 August 2015
//

import Foundation

class Player {
	var name: String

	init(name: String) {
		self.name = name
	}

	private var funds: Int = 1500 // Amount of money not including properties

	func removeFunds(amount: Int) {
		if funds > amount {
			funds -= amount
		}
	}
	func addFunds(amount: Int) {
		funds += amount
	}
	func getFunds() -> Int {
		return funds
	}
}

class Space {
	var name: String = ""

	init(name: String) {
		self.name = name
	}

	var rentPrice: Int { // Money to remove when on space. For taxes
		return 0
	}
}

// Includes Utilities/Railroads
class OwnedSpace: Space {
	enum Site: String {
		case Railroad = "Railroad"
		case Utility = "Utility"
	}

	var spaceType: Site

	init(name: String, spaceType: Site) {
		self.spaceType = spaceType
		super.init(name: name)
	}

	var price: Int {
		var price = 0

		switch spaceType {
		case .Railroad:
			price = 200
		case .Utility:
			price = 150
		}
		return price
	}

	override var rentPrice: Int {
		var price: Int = 0
		switch spaceType {
		case .Railroad: // Variable rent by # owned
			break
		case .Utility: //Variable rent by dice roll & # owned
			let dice = rollDice()
			price = (dice.0 + dice.1) * 40
		}
		return price
	}
}

func rollDice() -> (Int, Int) {
	let die1 = Int(arc4random_uniform(6) + 1)
	let die2 = Int(arc4random_uniform(6) + 1)

	return (die1, die2)
}
