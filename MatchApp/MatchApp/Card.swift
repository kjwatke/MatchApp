//
//  Card.swift
//  MatchApp
//
//  Created by Kevin  Watke on 1/25/22.
//

import Foundation

class Card {
	var imageName: String
	var isMatched: Bool
	var isFlipped: Bool = false
	
	init(imageName: String, isMatched: Bool, isFlipped: Bool) {
		self.imageName = imageName
		self.isMatched = isMatched
		self.isFlipped = isFlipped
	}
}
