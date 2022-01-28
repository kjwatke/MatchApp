//
//  CardCollectionViewCell.swift
//  MatchApp
//
//  Created by Kevin  Watke on 1/25/22.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var frontImageView: UIImageView!
	@IBOutlet weak var backImageView: UIImageView!
	
	var card: Card?
	
	func configureCell(withCard card: Card) {
		
		// Keep track of the card the cell represents
		self.card = card
		
		// Set the front image view to the image that represents the card.
		frontImageView.image = UIImage(named: card.imageName)
		
		// reset the state of the cell by checking flip status and showing front or back image accordingly
		if card.isMatched == true {
			backImageView.alpha = 0
			frontImageView.alpha = 0
			return
		}
		else {
			backImageView.alpha = 1
			frontImageView.alpha = 1
		}
		
		if card.isFlipped {
			flipUp(speed: 0)
		} else {
			flipDown(speed: 0, delay: 0)
		}
	}
	
	// Flip up animation
	func flipUp(speed: TimeInterval = 0.3) {
		UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
		card?.isFlipped = true
	}
	
	
	func flipDown(speed: TimeInterval = 0.3, delay: TimeInterval = 0.5) {
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
			UIView.transition(
				from: self.frontImageView,
				to: self.backImageView,
				duration: speed,
				options: [.showHideTransitionViews, .transitionFlipFromLeft],
				completion: nil)
		}
		
		// Flip down animation
		card?.isFlipped = false
	}
	
	
	func remove() {
		
		// Make the image views invisible
		backImageView.alpha = 0
		
		UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
			self.frontImageView.alpha = 0
		}, completion: nil)
	}
	
}
