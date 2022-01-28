//
//  CardModel.swift
//  MatchApp
//
//  Created by Kevin  Watke on 1/25/22.
//

import Foundation

class CardModel {
	func getCards() -> [Card] {
		// Declare an empty array
		var generatedCards = [Card]()
		
		// Randomly generate 8 pairs of cards
		for _ in 1...8 {
			
			// Generate a random number
			let randomNum = Int.random(in: 1...13)
			
			// Create two new card objects
			let cardOne = Card(imageName: "card\(randomNum)", isMatched: false, isFlipped: false)
			let cardTwo = Card(imageName: "card\(randomNum)", isMatched: false, isFlipped: false)
			
			// Add them to the array
			generatedCards += [cardOne, cardTwo]
			
			
		}
		
		// Randomize the cards within the array
		generatedCards.shuffle()
		
		// Return the Array
		return generatedCards
	}
}
