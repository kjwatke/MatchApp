	//
	//  ViewController.swift
	//  MatchApp
	//
	//  Created by Kevin  Watke on 1/25/22.
	//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var timerLabel: UILabel!
	
	let model = CardModel()
	var cardsArray = [Card]()
	var timer: Timer?
	var milliseconds: Int = 60 * 1000
	
	var firstFlippedCardIndex: IndexPath?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		collectionView.delegate = self
		collectionView.dataSource = self
		
		// Fill the array with new cards
		cardsArray = model.getCards()
		
		// Initialize timer
		timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
		RunLoop.main.add(timer!, forMode: .common)
	}
	
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		SoundManager.playSound(effect: .shuffle)
	}
	
	
}

// MARK: - Timer Methods
extension ViewController {
	
    @objc func timerFired() {
		
		// Decrement the counter
		milliseconds -= 1
		
		// Update the label
		let seconds: Double = Double(milliseconds) / 1000.0
		timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
		
		// Stop the timer if it reaches zero
		if milliseconds == 0 {
			timerLabel.textColor = UIColor.red
			timer?.invalidate()
			
			// Check if the user has cleared all the pairs
			checkForGameEnd()
		}
		
    }
}

// MARK: - Collection View Delegate methods

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
			// Return number of cards
		return cardsArray.count
	}
	
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		
			// Configure the state of this cell based on the properties of the Card that it represents
		let cardCell = cell as? CardCollectionViewCell
		
			// Get the card from the from the cards array
		let card = cardsArray[indexPath.row]
		
			// Finish configuring the cell
		cardCell?.configureCell(withCard: card)
		
		
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
			// Get a cell
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
		
			// Return Cell
		return cell
		
	}
	
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		// Check if there's any time remaining. Dont let the user interact if the time is zero
		if milliseconds <= 0 {
			return
		}
			// Get a reference to the cell that was tapped
		let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
		
			// Check the status of the card and determine which way to flip it
		if cell?.card?.isFlipped == false && cell!.card?.isMatched == false {
			cell?.flipUp()
			
			// Play sound
			SoundManager.playSound(effect: .flip)
			
				// Check if this is the first card taht was flpped or the second card
			if firstFlippedCardIndex == nil {
				
					// This is the first card flipped over
				firstFlippedCardIndex = indexPath
			}
			else {
					// Second card that is flipped
				
					// Run the comparison logic
				checkForMatch(indexPath)
			}
		}
	}
	
		// MARK: - Game Logic
	
	func checkForMatch(_ secondFlippedCardIndex: IndexPath) {
		
			// Get the two card objects for the two indicies and see if they match
		let cardOne = cardsArray[firstFlippedCardIndex!.row]
		let cardTwo = cardsArray[secondFlippedCardIndex.row]
		
			// Get the two collection view cells that represent card one and two
		let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
		let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
		
			// Compare the two cards
		if cardOne.imageName == cardTwo.imageName {
			
			// Play sound
			SoundManager.playSound(effect: .match)
			
			// Its a match. Set the status and remove them
			cardOne.isMatched = true
			cardTwo.isMatched = true
			
			cardOneCell?.remove()
			cardTwoCell?.remove()
			
			// Was that the last pair?
			checkForGameEnd()
		}
		else {
			
			// Play sound
			SoundManager.playSound(effect: .nomatch)
			
			// Its not a match. Flip them back over
			cardOne.isFlipped = false
			cardTwo.isFlipped = false
			
			cardOneCell?.flipDown()
			cardTwoCell?.flipDown()
		}
		
			// Reset the firstFlippedCardIndex property
		firstFlippedCardIndex = nil
		
	}
	
	
	func checkForGameEnd() {
		
		// Check if there is any card that is unmatched
		// Assume the user has won, loop through the cardsArray to verify all cards have been matched
		var hasWon = true
		
		for card in cardsArray {
			if !card.isMatched {
				// We've found a card that is unmatched
				hasWon = false
				break
			}
		}
		
		if hasWon {
			milliseconds = 0
			timer?.invalidate()
			timerLabel.text = "Time Remaining: 0:00"
			// User has won, show an alert
			showAlert(title: "Congratulations!", message: "You've won the game!")
			
		}
		else {
			
			// User hasn't won yet, check if there is time left
			if milliseconds <= 0 {
				showAlert(title: "Time's Up", message: "Sorry, better luck next time")
			}
			
		}
	}
	
	func showAlert(title: String, message: String) {
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default, handler: nil)
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
	
}

