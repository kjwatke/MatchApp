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
		
		// Declare an empty array to store numbers that we've already generated to ensure unique cards
		var generatedNumbers = [Int]()
		
		// Randomly generate 8 pairs of cards
		while generatedNumbers.count < 8 {
			
			// Generate a random number
			let randomNum = Int.random(in: 1...13)
			
			//
			if !generatedNumbers.contains(randomNum) {
				
					// Create two new card objects
				let cardOne = Card(imageName: "card\(randomNum)", isMatched: false, isFlipped: false)
				let cardTwo = Card(imageName: "card\(randomNum)", isMatched: false, isFlipped: false)
				
					// Add them to the array
				generatedCards += [cardOne, cardTwo]
				
					// Add this number to the list of generated numbers
				generatedNumbers.append(randomNum)
				
				print(randomNum)
			}
		}
		
		// Randomize the cards within the array
		generatedCards.shuffle()
		
		// Return the Array
		return generatedCards
	}
}
